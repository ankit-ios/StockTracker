//
//  AppFont.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import SwiftUI

struct AppFont {
    
    enum RobotoFont: String {
        case robotoBold = "Roboto-Bold"
        case robotoRegular = "Roboto-Regular"
    }
    
    static let title = AppFont.font(.robotoBold, with: 24)
    static let subtitle = AppFont.font(.robotoBold, with: 16)
    static let caption = AppFont.font(.robotoRegular, with: 14)
}

extension AppFont {
    
    static func font(_ name: RobotoFont, with size: CGFloat) -> Font {
        Font.custom(name.rawValue, size: size)
    }
}
