//
//  StockListViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
import Combine
import SwiftUI

// MARK: - StockListViewModel Actions and Input/Output protocols
struct StockListViewModelActions {
    let showStockDetail: (String) -> Void
}

protocol StockListViewModelInput: ObservableObject {
    func fetchStockList()
    func didSelectItem(_ symbol: String)
}

protocol StockListViewModelOutput: ObservableObject {
    var titles: StockListScreenTitle { get }
    var items: [Stock] { get }
    var loadingState: LoadingState { get }
    var errorModel: AlertModel { get }
}

// MARK: - StockListViewModel
typealias StockListViewModel = StockListViewModelInput & StockListViewModelOutput

final class DefaultStockListViewModel: ObservableObject, StockListViewModel {
    
    let titles = StockListScreenTitle()
    @Published private(set) var errorModel: AlertModel = .init(title: "", message: .constant(""))
    @Published private(set) var items: [Stock] = []
    @Published private(set) var loadingState: LoadingState = .idle
    
    private let actions: StockListViewModelActions?
    private let fetchStockListUseCase: FetchStockListUseCase
    private var stockListLoadTask: Cancellable? { willSet { stockListLoadTask?.cancel() } }
    private let errorTitle: String = "Failed loading stocks"
    
    init(fetchStockListUseCase: FetchStockListUseCase,
         actions: StockListViewModelActions? = nil) {
        self.fetchStockListUseCase = fetchStockListUseCase
        self.actions = actions
    }
}

extension DefaultStockListViewModel {
    
    func fetchStockList() {
        loadingState = .loading
        Task {
            stockListLoadTask = fetchStockListUseCase.fetchStockList(completion: { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let stockList):
                        self.items = stockList
                        self.loadingState = .loaded
                    case .failure(let error):
                        self.errorModel = .init(title: self.errorTitle, message: .constant(error.localizedDescription))
                        self.loadingState = .error
                    }
                }
            })
        }
    }
    
    func didSelectItem(_ symbol: String) {
        actions?.showStockDetail(symbol)
    }
}
