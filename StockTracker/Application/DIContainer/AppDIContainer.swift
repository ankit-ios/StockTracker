//
//  AppDIContainer.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol AppDIContainer {
    var apiDataTransferService: DataTransferService { get }

    func makeStockSceneDIContainer() -> StockSceneDIContainer
}

final class DefaultAppDIContainer: AppDIContainer {
    
    private var appConfiguration: AppConfiguration
    
    init(appConfiguration: AppConfiguration = DefaultAppConfiguration()) {
        self.appConfiguration = appConfiguration
    }
    
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
        DefaultStockSceneDIContainer(
            apiDataTransferService: apiDataTransferService
        )
    }
}
