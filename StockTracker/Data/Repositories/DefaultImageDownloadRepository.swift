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
    private let imageStorageService: ImageStorageService
    
    init(dataTransferService: DataTransferService, imageStorageService: ImageStorageService) {
        self.dataTransferService = dataTransferService
        self.imageStorageService = imageStorageService
    }
}

extension DefaultImageDownloadRepository: ImageDownloadRepository {
    
    func fetchImage(
        with imagePath: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()

        //Checking image in local Cache
        imageStorageService.loadImage(from: imagePath) { [weak self] imageData in
            if let imageData = imageData {
                completion(.success(imageData))
            } else {

                let endpoint = APIEndpoints.getImage(with: imagePath)
                task.networkTask = self?.dataTransferService.request(
                    with: endpoint
                ) { result in
                    switch result {
                    case .success(let responseDTO):
                        self?.imageStorageService.cacheImage(responseDTO, forKey: imagePath)
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

