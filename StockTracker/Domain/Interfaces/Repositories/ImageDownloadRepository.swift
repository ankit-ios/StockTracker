//
//  ImageDownloadRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol ImageDownloadRepository {
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) -> Cancellable?
}
