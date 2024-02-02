//
//  StockFlowCoordinator.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit

protocol StockFlowCoordinatorDependencies  {
    func makeStockListViewController(actions: StockListViewModelActions) -> UIViewController
    func makeStockDetailViewController(symbol: String, actions: StockDetailViewModelActions) -> UIViewController
}


/// Consider utilizing NavigationStack and NavigationPath instead of UINavigationController for improved navigation management.
final class StockFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: StockFlowCoordinatorDependencies
    private weak var stockListVC: UIViewController?
    
    init(navigationController: UINavigationController,
         dependencies: StockFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = StockListViewModelActions(showStockDetail: showStockDetail)
        let vc = dependencies.makeStockListViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        stockListVC = vc
    }
    
    private func showStockDetail(symbol: String) {
        let actions = StockDetailViewModelActions(dismissStockDetailVC: dismissStockDetailVC)
        let vc = dependencies.makeStockDetailViewController(symbol: symbol, actions: actions)
        vc.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func dismissStockDetailVC() {
        navigationController?.popViewController(animated: true)
    }
}
