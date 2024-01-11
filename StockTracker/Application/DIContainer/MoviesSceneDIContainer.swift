//
//  MoviesSceneDIContainer.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit
import SwiftUI

final class StockSceneDIContainer: StockFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeStockListUseCase() -> FetchStockListUseCase {
        DefaultFetchStockListUseCase(respository: makeStockListRepository())
    }
    
    func makeStockDetailUseCase() -> FetchStockDetailUseCase {
        DefaultFetchStockDetailUseCase(respository: makeStockDetailRepository())
    }
    
    // MARK: - Repositories
    func makeStockListRepository() -> StockListRepository {
        DefaultStockListRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeStockDetailRepository() -> StockDetailRepository {
        DefaultStockDetailRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    
    // MARK: - Stock List
    func makeStockListViewController(actions: StockListViewModelActions) -> StockListViewController {
        StockListViewController.create(with: makeStockListViewModel(actions: actions))
    }
    
    func makeStockListViewModel(actions: StockListViewModelActions) -> StockListViewModel {
        DefaultStockListViewModel(fetchStockListUseCase: makeStockListUseCase(), actions: actions)
    }
    
    // MARK: - Stock Detail
    func makeStockDetailViewController(symbol: String, actions: StockDetailViewModelActions) -> StockDetailViewController {
        StockDetailViewController.create(with: makeStockDetailViewModel(symbol: symbol, actions: actions))
    }
    
    func makeStockDetailViewModel(symbol: String, actions: StockDetailViewModelActions) -> StockDetailViewModel {
        DefaultStockDetailViewModel(symbol: symbol, fetchStockDetailUseCase: makeStockDetailUseCase(), actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeStokeFlowCoordinator(navigationController: UINavigationController) -> StockFlowCoordinator {
        StockFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
