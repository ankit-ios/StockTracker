//
//  StockDetailResponseDTO+Mapping.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

// MARK: - Data Transfer Object

struct StockDetailResponseDTO: Decodable {
    let symbol: String
    let image: String? //": "https://financialmodelingprep.com/image-stock/AXL.png",
    
    let companyName: String
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
    let price: Double?
    
    let description: String?
    
    let industry: String? //": "Auto Parts",
    let ceo: String? //": "Mr. David Charles Dauch",
    let sector: String? //": "Consumer Cyclical",
    let country: String? //": "US",
    let fullTimeEmployees: String? //": "19000",
    let phone: String? //": "313 758 2000",
    let address: String? //": "One Dauch Drive",
    let city: String? //": "Detroit",
    let state: String? //": "MI",
    let zip: String? //": "48211-1198",
    let website: String? //": "https://www.aam.com",
}

// MARK: - Mappings to Domain

extension StockDetailResponseDTO {
    func toDomain() -> StockDetail {
        return .init(symbol: symbol, image: image, companyName: companyName, currency: currency, stockExchange: stockExchange, exchangeShortName: exchangeShortName, price: price, description: description, industry: industry, ceo: ceo, sector: sector, country: country, fullTimeEmployees: fullTimeEmployees, phone: phone, address: address, city: city, state: state, zip: zip, website: website)
    }
}
