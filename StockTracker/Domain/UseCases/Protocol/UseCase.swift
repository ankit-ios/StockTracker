//
//  UseCase.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
