//
//  StockListRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol StockListRepository {
    @discardableResult
    func fetchStockList(
        completion: @escaping (Result<[Stock], Error>) -> Void
    )-> Cancellable?
}
