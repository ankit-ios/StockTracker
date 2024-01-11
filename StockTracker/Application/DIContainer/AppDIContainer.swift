//
//  AppDIContainer.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "apikey": appConfiguration.apiKey
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeStockSceneDIContainer() -> StockSceneDIContainer {
        let dependencies = StockSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return StockSceneDIContainer(dependencies: dependencies)
    }
}
