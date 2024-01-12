//
//  ImageDownloadRepositoryMock.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import Foundation
@testable import StockTracker

enum ImageDownloadRepositoryMockError: Error {
    case failedDownloading
}

class ImageDownloadRepositoryMock: ImageDownloadRepository {
    let result: Result<Data?, Error>
    init(result: Result<Data?, Error>) {
        self.result = result
    }
    
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable? {
        completion(result)
        return nil
    }
}
