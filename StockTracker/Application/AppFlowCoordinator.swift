//
//  AppFlowCoordinator.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var appDIContainer: AppDIContainer { get }
    func start()
}

final class AppFlowCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var appDIContainer: AppDIContainer
    
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
