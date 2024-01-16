//
//  StockDetailItemViewModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

struct StockDetailItemViewModel {
    let title: String
    let description: String?
    var enableDataDetection: Bool
    
    init(title: String, description: String?, enableDataDetection: Bool = false) {
        self.title = title
        self.description = enableDataDetection ? description?.removeSpaces() : description
        self.enableDataDetection = enableDataDetection
    }
}
