//
//  DefaultImageDownloadRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

import Foundation

final class DefaultImageDownloadRepository {
    
    private let dataTransferService: DataTransferService
    private let imageResponseStorage: ImageResponseStorage
    
    init(dataTransferService: DataTransferService, imageResponseStorage: ImageResponseStorage) {
        self.dataTransferService = dataTransferService
        self.imageResponseStorage = imageResponseStorage
    }
}

extension DefaultImageDownloadRepository: ImageDownloadRepository {
    
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()

        //Checking image in local Cache
        imageResponseStorage.loadImage(from: imagePath) { [weak self] imageData in
            if let imageData = imageData {
                completion(.success(imageData))
            } else {

                let endpoint = APIEndpoints.getImage(with: imagePath)
                task.networkTask = self?.dataTransferService.request(
                    with: endpoint
                ) { result in
                    switch result {
                    case .success(let responseDTO):
                        self?.imageResponseStorage.cacheImage(responseDTO, forKey: imagePath)
                        completion(.success(responseDTO))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        return task
    }
}

