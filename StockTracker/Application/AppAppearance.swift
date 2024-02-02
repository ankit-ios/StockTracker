//
//  AppAppearance.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation
import UIKit

struct AppColor {
    static let foregroundColor: UIColor = .white
    static let backgroundColor: UIColor = .init(red: 37/255.0, green: 37/255.0, blue: 37.0/255.0, alpha: 1.0)
}

final class AppAppearance {
    
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: AppColor.foregroundColor]
        appearance.backgroundColor = AppColor.backgroundColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColor.foregroundColor]
    }
}
