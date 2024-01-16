//
//  StockDetailSectionModel.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

// MARK: - StockDetailDataSource

enum StockDetailCellType {
    case textCell
    case imageCell
    case readMoreCell
}

struct StockDetailSectionModel: Identifiable {
    let id = UUID()
    var title: String
    var items: [StockDetailItemDataSource]
}

struct StockDetailItemDataSource: Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let cellType: StockDetailCellType
    let enableDataDetection: Bool
    
    init(title: String, description: String?, cellType: StockDetailCellType = .textCell, enableDataDetection: Bool = false) {
        self.title = title
        self.description = description
        self.cellType = cellType
        self.enableDataDetection = enableDataDetection
    }
}
