//
//  AppFlowCoordinator.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let stockSceneDIContainer = appDIContainer.makeStockSceneDIContainer()
        let flow = stockSceneDIContainer.makeStokeFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
