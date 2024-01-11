//
//  StockDetailViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
import UIKit

struct StockDetailViewModelActions {
    let dismissStockDetailVC: () -> Void
}

protocol StockDetailViewModelInput {
    func fetchStockDetail()
    func downloadStockLogo()
}

protocol StockDetailViewModelOutput {
    var sections: [String] { get }
    var dataSource: [[StockDetailDataSource]] { get }
    var loading: Observable<Bool> { get }
    var stockDetail: Observable<StockDetail?> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
    var stockLogo: Observable<UIImage?> { get }
}

typealias StockDetailViewModel = StockDetailViewModelInput & StockDetailViewModelOutput

final class DefaultStockDetailViewModel: StockDetailViewModel {
    
    let loading: Observable<Bool> = .init(false)
    let stockDetail: Observable<StockDetail?> = .init(nil)
    let screenTitle: String
    let error: Observable<String> = .init("")
    let errorTitle: String = "Failed loading Stock details"
    var stockLogo: Observable<UIImage?> = .init(.none)
    
    let sections: [String] = ["General Information", "Company Details", "Contact Information"]
    var dataSource: [[StockDetailDataSource]] { getDataSource() }
    
    private let stockSymbol: String
    private let actions: StockDetailViewModelActions?
    private let fetchStockDetailUseCase: FetchStockDetailUseCase
    private let imageDownloadUseCase: ImageDownloadUseCase
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
    
    func fetchStockDetail() {
        loading.value = true
        stockDetailLoadTask = fetchStockDetailUseCase.fetchStockDetail(symbol: stockSymbol) { [weak self] result in
            switch result {
            case .success(let stockDetail):
                self?.stockDetail.value = stockDetail
            case .failure(let error):
                self?.error.value = error.localizedDescription
            }
            self?.loading.value = false
        }
    }
    
    func downloadStockLogo() {
        guard imageDownloadingState == .notStarted else { return }
        guard let imageUrl = stockDetail.value?.image else { return }
        
        imageDownloadingState = .inProgress
        stockDetailLoadTask = imageDownloadUseCase.fetchImage(
            with: imageUrl, completion: { [weak self] result in
                switch result {
                case .success(let imageData):
                    if let imageData = imageData {
                        self?.stockLogo.value = UIImage(data: imageData)
                    }
                case .failure(let error):
                    self?.error.value = error.localizedDescription
                }
                self?.imageDownloadingState = .done
            })
    }
    
    private func getDataSource() -> [[StockDetailDataSource]] {
        let stockDetail = stockDetail.value
        return [
            // General Information Section
            [
                .init(title: "Company Name", value: stockDetail?.companyName),
                .init(title: "Company Logo", value: stockDetail?.image, cellType: .image),
                .init(title: "Currency", value: stockDetail?.currency),
                .init(title: "Stock Exchange", value: stockDetail?.stockExchange),
                .init(title: "Exchange Short Name", value: stockDetail?.exchangeShortName),
                .init(title: "Price", value: stockDetail?.price.map { String($0) })
            ],
            // Company Details Section
            [
                .init(title: "Description", value: stockDetail?.description, cellType: .readMore),
                .init(title: "Industry", value: stockDetail?.industry),
                .init(title: "CEO", value: stockDetail?.ceo),
                .init(title: "Sector", value: stockDetail?.sector),
                .init(title: "Country", value: stockDetail?.country),
                .init(title: "Full-Time Employees", value: stockDetail?.fullTimeEmployees),
                .init(title: "Website", value: stockDetail?.website, enableDataDetection: true)
            ],
            // Contact Information Section
            [
                .init(title: "Phone", value: stockDetail?.phone, enableDataDetection: true),
                .init(title: "Address", value: stockDetail?.address),
                .init(title: "City", value: stockDetail?.city),
                .init(title: "State", value: stockDetail?.state),
                .init(title: "Zip", value: stockDetail?.zip)
            ]
        ]
    }
}

private extension DefaultStockDetailViewModel {
    enum ImageDownloadingState {
        case notStarted
        case inProgress
        case done
    }
}

// MARK: - StockDetailDataSource

enum StockDetailCellType {
    case text
    case image
    case readMore
}

struct StockDetailDataSource {
    let id = UUID().uuidString
    let title: String
    let value: String?
    let cellType: StockDetailCellType
    let enableDataDetection: Bool
    
    init(title: String, value: String?, cellType: StockDetailCellType = .text, enableDataDetection: Bool = false) {
        self.title = title
        self.value = value
        self.cellType = cellType
        self.enableDataDetection = enableDataDetection
    }
}
