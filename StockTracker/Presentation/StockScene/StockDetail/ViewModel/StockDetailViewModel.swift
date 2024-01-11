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
}

