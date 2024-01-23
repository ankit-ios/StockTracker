//
//  StockListRepositoryMock.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import Foundation
@testable import StockTracker

enum StockListRepositoryMockError: Error {
    case failedFetching
}

final class StockListRepositoryMock: StockListRepository {
    
    let result: Result<[Stock], Error>
    init(result: Result<[Stock], Error>) {
        self.result = result
    }
    
    func fetchStockList(completion: @escaping (Result<[Stock], Error>) -> Void) -> Cancellable? {
        completion(result)
        return nil
    }
}
