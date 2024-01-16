//
//  StockListViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
import Combine
import SwiftUI

struct StockListViewModelActions {
    let showStockDetail: (String) -> Void
}

protocol StockListViewModelInput {
    func fetchStockList()
    func didSelectItem(_ symbol: String)
}

protocol StockListViewModelOutput {
    var screenTitle: String { get }
    var loadingTitle: String { get }
    var loadingData: Bool { get }
    var items: [Stock] { get }
    var showError: Bool { get }
    var errorModel: AlertModel { get }
}

final class StockListViewModel: ObservableObject, StockListViewModelInput, StockListViewModelOutput {
    
    let screenTitle: String = "Stock List"
    let loadingTitle: String = "Fetching Stock List..."
    private let errorTitle: String = "Failed loading stocks"
    
    @Published var loadingData: Bool = false
    @Published var showError: Bool = false
    @Published var errorModel: AlertModel = .init(title: "", message: .constant(""))
    @Published var items: [Stock] = []
    
    private let actions: StockListViewModelActions?
    private let fetchStockListUseCase: FetchStockListUseCase
    private var stockListLoadTask: Cancellable? { willSet { stockListLoadTask?.cancel() } }
    
    init(fetchStockListUseCase: FetchStockListUseCase,
         actions: StockListViewModelActions? = nil) {
        self.fetchStockListUseCase = fetchStockListUseCase
        self.actions = actions
    }
    
    func fetchStockList() {
        loadingData = true
        stockListLoadTask = fetchStockListUseCase.fetchStockList(completion: { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let stockList):
                    self?.items = stockList
                case .failure(let error):
                    self?.errorModel = .init(title: self?.errorTitle ?? "Error", message: .constant(error.localizedDescription))
                    self?.showError = true
                }
                self?.loadingData = false
            }
        })
    }
    
    func didSelectItem(_ symbol: String) {
        actions?.showStockDetail(symbol)
    }
}
