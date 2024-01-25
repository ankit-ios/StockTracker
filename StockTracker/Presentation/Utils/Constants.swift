//
//  Constants.swift
//  StockTracker
//
//  Created by Ankit Sharma on 25/01/24.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case error
}

enum ImageDownloadingState {
    case notStarted
    case inProgress
    case done
}

struct StockListScreenTitle {
    let screenTitle: String = "Stock List"
    let loadingTitle: String = "Fetching Stock List..."
    let unavailableViewTitle = "No stock list found"
    let unavailableViewDesc = "Try fetching again."
}

struct StockDetailScreenTitle {
    let loadingTitle: String = "Fetching Stock Details..."
    let errorTitle = "Failed loading Stock details"
    let unavailableViewTitle = "No stock details found"
    let unavailableViewDesc = "Try fetching again."
}
