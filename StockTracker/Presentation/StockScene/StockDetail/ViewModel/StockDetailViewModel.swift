//
//  StockDetailViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
import UIKit
import Combine

struct StockDetailViewModelActions {
    let dismissStockDetailVC: () -> Void
}

protocol StockDetailViewModelInput {
    func fetchStockDetail()
    func downloadImage(for url: String?)
}

protocol StockDetailViewModelOutput {
    var screenTitle: String { get }
    var loadingTitle: String { get }
    var dataSource: [StockDetailSectionModel] { get }
    var loadingData: Bool { get }
    var showError: Bool { get }
    var errorModel: AlertModel { get }
    var stockLogoImage: UIImage? { get }
}

final class StockDetailViewModel: ObservableObject, StockDetailViewModelOutput {
    
    let screenTitle: String
    let loadingTitle: String = "Fetching Stock Details..."
    
    @Published var loadingData: Bool = false
    @Published var showError: Bool = false
    @Published var errorModel: AlertModel = .init(title: "", message: .constant(""))
    @Published var stockLogoImage: UIImage?
    @Published var dataSource: [StockDetailSectionModel] = []
    
    private let stockSymbol: String
    private let actions: StockDetailViewModelActions?
    private let fetchStockDetailUseCase: FetchStockDetailUseCase
    private let imageDownloadUseCase: ImageDownloadUseCase
    private let errorTitle: String = "Failed loading Stock details"
    private var stockDetailLoadTask: Cancellable? { willSet { stockDetailLoadTask?.cancel() } }
    private var imageDownloadingState: ImageDownloadingState = .notStarted
    
    init(symbol: String,
         fetchStockDetailUseCase: FetchStockDetailUseCase,
         imageDownloadUseCase: ImageDownloadUseCase,
         actions: StockDetailViewModelActions? = nil) {
        self.stockSymbol = symbol
        self.screenTitle = symbol
        self.fetchStockDetailUseCase = fetchStockDetailUseCase
        self.imageDownloadUseCase = imageDownloadUseCase
        self.actions = actions
    }
    
    private func getDataSource(from stockDetail: StockDetail) -> [StockDetailSectionModel] {
        return [
            // General Information Section
            .init(title: "General Information", items: [
                .init(title: "Company Name", description: stockDetail.companyName),
                .init(title: "Company Logo", description: stockDetail.image, cellType: .imageCell),
                .init(title: "Currency", description: stockDetail.currency),
                .init(title: "Stock Exchange", description: stockDetail.stockExchange),
                .init(title: "Exchange Short Name", description: stockDetail.exchangeShortName),
                .init(title: "Price", description: stockDetail.price.map { String($0) })
            ]),
            // Company Details Section
            .init(title: "Company Details", items: [
                .init(title: "Description", description: stockDetail.description, cellType: .readMoreCell),
                .init(title: "Industry", description: stockDetail.industry),
                .init(title: "CEO", description: stockDetail.ceo),
                .init(title: "Sector", description: stockDetail.sector),
                .init(title: "Country", description: stockDetail.country),
                .init(title: "Full-Time Employees", description: stockDetail.fullTimeEmployees),
                .init(title: "Website", description: stockDetail.website, enableDataDetection: true)
            ]),
            // Contact Information Section
            .init(title: "Contact Information", items: [
                .init(title: "Phone", description: stockDetail.phone, enableDataDetection: true),
                .init(title: "Address", description: stockDetail.address),
                .init(title: "City", description: stockDetail.city),
                .init(title: "State", description: stockDetail.state),
                .init(title: "Zip", description: stockDetail.zip)
            ])
        ]
    }
}

extension StockDetailViewModel: StockDetailViewModelInput {
    
    func fetchStockDetail() {
        loadingData = true
        stockDetailLoadTask = fetchStockDetailUseCase.fetchStockDetail(symbol: stockSymbol) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stockDetail):
                    self?.dataSource = self?.getDataSource(from: stockDetail) ?? []
                case .failure(let error):
                    self?.errorModel = .init(title: self?.errorTitle ?? "Error", message: .constant(error.localizedDescription))
                    self?.showError = true
                }
                self?.loadingData = false
            }
        }
    }
    
    func downloadImage(for url: String?) {
        guard imageDownloadingState == .notStarted else { return }
        guard let imageUrl = url else { return }
        
        imageDownloadingState = .inProgress
        stockDetailLoadTask = imageDownloadUseCase.fetchImage(
            with: imageUrl, completion: { [weak self] result in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let imageData):
                        if let imageData = imageData {
                            self?.stockLogoImage = UIImage(data: imageData)
                        }
                    case .failure(let error):
                        self?.errorModel = .init(title: self?.errorTitle ?? "Error", message: .constant(error.localizedDescription))
                        self?.showError = true
                    }
                    self?.imageDownloadingState = .done
                }
            })
    }
}

private extension StockDetailViewModel {
    enum ImageDownloadingState {
        case notStarted
        case inProgress
        case done
    }
}
