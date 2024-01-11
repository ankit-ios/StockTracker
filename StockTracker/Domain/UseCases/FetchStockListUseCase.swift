//
//  FetchStocksUseCase.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

typealias StockListDomainResponse = (Result<[Stock], Error>) -> Void

protocol FetchStockListUseCase {
    func fetchStockList(completion: @escaping StockListDomainResponse) -> Cancellable?
}

final class DefaultFetchStockListUseCase: FetchStockListUseCase {
    
    private let respository: StockListRepository
    
    init(respository: StockListRepository) {
        self.respository = respository
    }
    
    func fetchStockList(completion: @escaping StockListDomainResponse) -> Cancellable? {
        return respository.fetchStockList { result in
            completion(result)
        }
    }
}
