//
//  FetchStockDetailUseCase.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

typealias StockDetailDomainResponse = (Result<StockDetail, Error>) -> Void

protocol FetchStockDetailUseCase {
    func fetchStockDetail(symbol: String, completion: @escaping StockDetailDomainResponse) -> Cancellable?
}

final class DefaultFetchStockDetailUseCase: FetchStockDetailUseCase {
    
    private let respository: StockDetailRepository
    
    init(respository: StockDetailRepository) {
        self.respository = respository
    }
    
    func fetchStockDetail(
        symbol: String,
        completion: @escaping StockDetailDomainResponse
    ) -> Cancellable? {
        return respository.fetchStockDetail(symbol: symbol) { result in
            completion(result)
        }
    }
}
