//
//  StockDetailRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol StockDetailRepository {
    @discardableResult
    func fetchStockDetail(
        symbol: String,
        completion: @escaping (Result<StockDetail, Error>) -> Void
    ) -> Cancellable?
}
