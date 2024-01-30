//
//  Stock.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
}
