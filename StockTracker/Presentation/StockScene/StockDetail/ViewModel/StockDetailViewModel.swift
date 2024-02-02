//
//  StockDetailViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
import UIKit
import Combine

// MARK: - StockDetailViewModel Actions and Input/Output protocols
struct StockDetailViewModelActions {
    let dismissStockDetailVC: () -> Void
}

protocol StockDetailViewModelInput: ObservableObject {
    func fetchStockDetail()
    func downloadImage(for url: String?)
    func dismiss()
}

protocol StockDetailViewModelOutput: ObservableObject {
    var screenTitle: String { get }
    var titles: StockDetailScreenTitle { get }
    var dataSource: [StockDetailSectionModel] { get }
    var loadingState: LoadingState { get set }
    var imageDownloadingState: ImageDownloadingState { get set }
    var errorModel: AlertModel { get }
    var stockLogoImage: UIImage? { get set }
}

// MARK: - StockDetailViewModel Actions and Input/Output protocols
typealias StockDetailViewModel = StockDetailViewModelInput & StockDetailViewModelOutput

final class DefaultStockDetailViewModel: ObservableObject, StockDetailViewModel {
    
    let screenTitle: String
    let titles = StockDetailScreenTitle()
    @Published private(set) var errorModel: AlertModel = .init(title: "", message: .constant(""))
    @Published private(set) var dataSource: [StockDetailSectionModel] = []
    @Published var loadingState: LoadingState = .idle
    @Published var imageDownloadingState: ImageDownloadingState = .notStarted
    @Published var stockLogoImage: UIImage?
    
    private let stockSymbol: String
    private let actions: StockDetailViewModelActions?
    private let fetchStockDetailUseCase: FetchStockDetailUseCase
    private let imageDownloadUseCase: ImageDownloadUseCase
    private var stockDetailLoadTask: Cancellable? { willSet { stockDetailLoadTask?.cancel() } }
    
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

extension DefaultStockDetailViewModel {
    
    func fetchStockDetail() {
        loadingState = .loading
        Task {
            stockDetailLoadTask = fetchStockDetailUseCase
                .fetchStockDetail(symbol: stockSymbol) { [weak self] result in
                    guard let self else { return }
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let stockDetail):
                            self.dataSource = self.getDataSource(from: stockDetail)
                            self.loadingState = .loaded
                        case .failure(let error):
                            self.errorModel = .init(title: self.titles.errorTitle, message: .constant(error.localizedDescription))
                            self.loadingState = .error
                        }
                    }
                }
        }
    }
    
    func downloadImage(for url: String?) {
        guard imageDownloadingState == .notStarted else { return }
        guard let imageUrl = url else { return }
        
        imageDownloadingState = .inProgress
        Task {
            stockDetailLoadTask = imageDownloadUseCase
                .fetchImage(with: imageUrl, completion: { [weak self] result in
                    guard let self else { return }
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            if let imageData {
                                self.stockLogoImage = UIImage(data: imageData)
                            }
                            self.imageDownloadingState = .done
                        case .failure(let error):
                            self.errorModel = .init(title: self.titles.imageDownloadErrorTitle, message: .constant(error.localizedDescription))
                            self.imageDownloadingState = .error
                        }
                    }
                })
        }
    }
    
    func dismiss() {
        actions?.dismissStockDetailVC()
    }
}
