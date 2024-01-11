//
//  RepositoryTask.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
