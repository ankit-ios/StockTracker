//
//  StockSceneDIContainer.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit
import SwiftUI

protocol StockSceneDIContainer {
    var apiDataTransferService: DataTransferService { get }
    var imageStorageService: ImageStorageService { get }
    
    func makeStokeFlowCoordinator(navigationController: UINavigationController) -> StockFlowCoordinator
}

///Using protocol inside #Preview of View to exposing viewModels
protocol StockSceneDIContainerViewModel {
    func makeStockListViewModel(actions: StockListViewModelActions) -> any StockListViewModel
    func makeStockDetailViewModel(symbol: String, actions: StockDetailViewModelActions) -> any StockDetailViewModel
}

final class DefaultStockSceneDIContainer: StockSceneDIContainer {
 
    var apiDataTransferService: DataTransferService
    var imageStorageService: ImageStorageService
    
    init(apiDataTransferService: DataTransferService, imageStorageService: ImageStorageService) {
        self.apiDataTransferService = apiDataTransferService
        self.imageStorageService = imageStorageService
    }
    
    // Flow Coordinators
    func makeStokeFlowCoordinator(navigationController: UINavigationController) -> StockFlowCoordinator {
        StockFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension DefaultStockSceneDIContainer: StockFlowCoordinatorDependencies {
  
    func makeStockListViewController(actions: StockListViewModelActions) -> UIViewController {
        UIHostingController(rootView: StockListView<DefaultStockListViewModel>(viewModel: makeStockListViewModel(actions: actions) as! DefaultStockListViewModel))
    }
    
    func makeStockDetailViewController(symbol: String, actions: StockDetailViewModelActions) -> UIViewController {
        UIHostingController(rootView: StockDetailView<DefaultStockDetailViewModel>(viewModel: makeStockDetailViewModel(symbol: symbol, actions: actions) as! DefaultStockDetailViewModel))
    }
}

extension DefaultStockSceneDIContainer: StockSceneDIContainerViewModel {

    func makeStockListViewModel(actions: StockListViewModelActions) -> any StockListViewModel {
        DefaultStockListViewModel(fetchStockListUseCase: makeStockListUseCase(), actions: actions)
    }
    
    func makeStockDetailViewModel(symbol: String, actions: StockDetailViewModelActions) -> any StockDetailViewModel {
        DefaultStockDetailViewModel(
            symbol: symbol,
            fetchStockDetailUseCase: makeStockDetailUseCase(),
            imageDownloadUseCase: makeImageDownloadUseCase(),
            actions: actions)
    }
}

private extension DefaultStockSceneDIContainer {
    
    // MARK: - Use Cases
    func makeStockListUseCase() -> FetchStockListUseCase {
        DefaultFetchStockListUseCase(respository: makeStockListRepository())
    }
    
    func makeStockDetailUseCase() -> FetchStockDetailUseCase {
        DefaultFetchStockDetailUseCase(respository: makeStockDetailRepository())
    }
    
    func makeImageDownloadUseCase() -> ImageDownloadUseCase {
        DefaultImageDownloadUseCase(respository: makeStockDetailRepository())
    }
    
    // MARK: - Repositories
    func makeStockListRepository() -> StockListRepository {
        DefaultStockListRepository(dataTransferService: apiDataTransferService)
    }
    
    func makeStockDetailRepository() -> StockDetailRepository {
        DefaultStockDetailRepository(dataTransferService: apiDataTransferService)
    }
    
    func makeStockDetailRepository() -> ImageDownloadRepository {
        DefaultImageDownloadRepository(dataTransferService: apiDataTransferService, imageStorageService: imageStorageService)
    }
}
