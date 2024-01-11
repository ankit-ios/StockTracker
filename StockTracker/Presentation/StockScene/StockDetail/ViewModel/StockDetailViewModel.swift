//
//  StockDetailViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation

struct StockDetailViewModelActions {
    let dismissStockDetailVC: () -> Void
}

protocol StockDetailViewModelInput {
    func fetchStockDetail()
}

protocol StockDetailViewModelOutput {
    var sections: [String] { get }
    var dataSource: [[StockDetailDataSource]] { get }
    var stockDetail: Observable<StockDetail?> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
}

typealias StockDetailViewModel = StockDetailViewModelInput & StockDetailViewModelOutput

final class DefaultStockDetailViewModel: StockDetailViewModel {
    
    let stockDetail: Observable<StockDetail?> = .init(nil)
    let screenTitle: String
    let error: Observable<String> = .init("")
    let errorTitle: String = "Failed loading Stock details"
    
    let sections: [String] = ["General Information", "Company Details", "Contact Information"]
    var dataSource: [[StockDetailDataSource]] { getDataSource() }
    
    private let stockSymbol: String
    private let actions: StockDetailViewModelActions?
    private let fetchStockDetailUseCase: FetchStockDetailUseCase
    private var stockDetailLoadTask: Cancellable? { willSet { stockDetailLoadTask?.cancel() } }
    
    init(symbol: String,
         fetchStockDetailUseCase: FetchStockDetailUseCase,
         actions: StockDetailViewModelActions? = nil) {
        self.stockSymbol = symbol
        self.screenTitle = symbol
        self.fetchStockDetailUseCase = fetchStockDetailUseCase
        self.actions = actions
    }
    
    func fetchStockDetail() {
        stockDetailLoadTask = fetchStockDetailUseCase.fetchStockDetail(symbol: stockSymbol) { result in
            switch result {
            case .success(let stockDetail):
                self.stockDetail.value = stockDetail
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
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
                .init(title: "Website", value: stockDetail?.website)
            ],
            // Contact Information Section
            [
                .init(title: "Phone", value: stockDetail?.phone),
                .init(title: "Address", value: stockDetail?.address),
                .init(title: "City", value: stockDetail?.city),
                .init(title: "State", value: stockDetail?.state),
                .init(title: "Zip", value: stockDetail?.zip)
            ]
        ]
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
    
    init(title: String, value: String?, cellType: StockDetailCellType = .text) {
        self.title = title
        self.value = value
        self.cellType = cellType
    }
}
