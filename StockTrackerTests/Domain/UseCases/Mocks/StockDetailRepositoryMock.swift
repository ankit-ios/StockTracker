//
//  StockDetailRepositoryMock.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import Foundation
@testable import StockTracker

enum StockDetailRepositoryMockError: Error {
    case failedFetching
}

final class StockDetailRepositoryMock: StockDetailRepository {
    let result: Result<StockDetail, Error>
    let repositoryTask: RepositoryTask?
    
    init(result: Result<StockDetail, Error>, repositoryTask: RepositoryTask? = nil) {
        self.result = result
        self.repositoryTask = repositoryTask
    }
    
    func fetchStockDetail(symbol: String, completion: @escaping (Result<StockDetail, Error>) -> Void) -> Cancellable? {
        switch result {
        case .success(let detail):
            if detail.symbol == symbol {
                completion(.success(detail))
            } else {
                completion(.success(StockDetail.empty()))
            }
        case .failure(let error):
            completion(.failure(error))
        }
        return repositoryTask
    }
}
