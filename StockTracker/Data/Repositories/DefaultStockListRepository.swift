//
//  DefaultStockListRepository.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultStockListRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultStockListRepository: StockListRepository {
    func fetchStockList(completion: @escaping (Result<[Stock], Error>) -> Void) -> Cancellable? {
        let requestDTO = StockListRequestDTO(query: "A", currency: "USD", limit: 30)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getStockList(with: requestDTO)

        task.networkTask = self.dataTransferService.request(
            with: endpoint
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.map { $0.toDomain()} ))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
