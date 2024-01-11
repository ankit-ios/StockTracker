//
//  StockLogoRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol StockLogoRepository {
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
