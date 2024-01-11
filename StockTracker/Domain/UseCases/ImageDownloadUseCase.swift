//
//  ImageDownloadUseCase.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation

typealias ImageDownloadDomainResponse = (Result<Data?, Error>) -> Void

protocol ImageDownloadUseCase {
    func fetchImage(
        with path: String,
        completion: @escaping ImageDownloadDomainResponse) -> Cancellable?
}

final class DefaultImageDownloadUseCase: ImageDownloadUseCase {
    
    private let respository: ImageDownloadRepository
    
    init(respository: ImageDownloadRepository) {
        self.respository = respository
    }
    
    func fetchImage(with path: String, completion: @escaping ImageDownloadDomainResponse) -> Cancellable? {
        respository.fetchImage(with: path) { result in
            completion(result)
        }
    }
}
