//
//  SceneDelegate.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    let appDIContainer: AppDIContainer = DefaultAppDIContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        coordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        coordinator?.start()
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

