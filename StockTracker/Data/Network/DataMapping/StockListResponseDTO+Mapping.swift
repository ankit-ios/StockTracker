//
//  StockListResponseDTO+Mapping.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

// MARK: - Data Transfer Object
struct StockListDTO: Decodable {
    let symbol: String
    let name: String
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
}

// MARK: - Mappings to Domain
extension StockListDTO {
    func toDomain() -> Stock {
        return .init(symbol: symbol, name: name, currency: currency, stockExchange: stockExchange, exchangeShortName: exchangeShortName)
    }
}
