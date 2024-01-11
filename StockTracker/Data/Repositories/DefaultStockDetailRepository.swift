//
//  DefaultStockDetailRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

final class DefaultStockDetailRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultStockDetailRepository: StockDetailRepository {
    func fetchStockDetail(symbol: String, completion: @escaping (Result<StockDetail, Error>) -> Void) -> Cancellable? {
        let requestDTO = StockDetailRequestDTO()
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getStockDetail(with: symbol, stockDetailDTO: requestDTO)

        task.networkTask = self.dataTransferService.request(
            with: endpoint
        ) { result in
            switch result {
            case .success(let responseDTO):
                if let responseDTO = responseDTO.first {
                    completion(.success(responseDTO.toDomain()))
                } else {
                    completion(.failure(NetworkError.cancelled))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
