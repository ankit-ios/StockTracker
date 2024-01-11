//
//  StockListViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation

struct StockListViewModelActions {
    let showStockDetail: (String) -> Void
}

protocol StockListViewModelInput {
    func fetchStockList()
    func didSelectItem(at index: Int)
}

protocol StockListViewModelOutput {
    var loading: Observable<Bool> { get }
    var items: Observable<[Stock]> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
}

typealias StockListViewModel = StockListViewModelInput & StockListViewModelOutput

final class DefaultStockListViewModel: StockListViewModel {
    var loading: Observable<Bool> = .init(false)
    let error: Observable<String> = .init("")
    let screenTitle: String = "Stock List"
    let errorTitle: String = "Failed loading stocks"
    let items: Observable<[Stock]> = Observable([])

    private let actions: StockListViewModelActions?
    private let fetchStockListUseCase: FetchStockListUseCase
    private var stockListLoadTask: Cancellable? { willSet { stockListLoadTask?.cancel() } }
    
    init(fetchStockListUseCase: FetchStockListUseCase,
         actions: StockListViewModelActions? = nil) {
        self.fetchStockListUseCase = fetchStockListUseCase
        self.actions = actions
    }
    
    func fetchStockList() {
        loading.value = true
        stockListLoadTask = fetchStockListUseCase.fetchStockList(completion: { result in
            switch result {
            case .success(let stockList):
                self.items.value = stockList
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
            self.loading.value = false
        })
    }

    func didSelectItem(at index: Int) {
        actions?.showStockDetail(items.value[index].symbol)
    }
}
