//
//  Stock+Stub.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation
@testable import StockTracker

extension Stock {
    static func stub(symbol: String = "AZ",
                     name: String = "A2Z Smart Technologies Corp.",
                     currency: String? = "USD",
                     stockExchange: String? = "NASDAQ Capital Market",
                     exchangeShortName: String? = "NASDAQ") -> Self {
        Stock(symbol: symbol,
              name: name,
              currency: currency,
              stockExchange: stockExchange,
              exchangeShortName: exchangeShortName)
    }
    
    static let mockData: [Stock] = [
        Stock.stub(symbol: "AY", name: "Atlantica Sustainable Infrastructure plc", currency: "USD", stockExchange: "NASDAQ Global Select", exchangeShortName: "NASDAQ"),
        Stock.stub(symbol: "AU", name: "AngloGold Ashanti Limited", currency: "USD", stockExchange: "New York Stock Exchange", exchangeShortName: "NYSE")
    ]
}

extension StockDetail {
    static func stub(
        symbol: String = "AXL",
        image: String? = "https://financialmodelingprep.com/image-stock/AXL.png",
        companyName: String = "American Axle & Manufacturing Holdings, Inc.",
        currency: String? = "USD",
        stockExchange: String? = "New York Stock Exchange",
        exchangeShortName: String? = "NYSE",
        price: Double? = 8.29,
        description: String? = "American Axle & Manufacturing Holdings, Inc., together with its subsidiaries, designs, engineers, and manufactures driveline and metal forming technologies that supports electric, hybrid, and internal combustion vehicles in the United States, Mexico, South America, China, other Asian countries, and Europe. It operates through Driveline and Metal Forming segments.",
        industry: String? = "Auto Parts",
        ceo: String? = "Mr. David Charles Dauch",
        sector: String? = "Consumer Cyclical",
        country: String? = "US",
        fullTimeEmployees: String? = "19000",
        phone: String? = "313 758 2000",
        address: String? = "One Dauch Drive",
        city: String? = "Detroit",
        state: String? = "MI",
        zip: String? = "48211-1198",
        website: String? = "https://www.aam.com") -> Self {
            StockDetail(symbol: symbol, image: image, companyName: companyName, currency: currency, stockExchange: stockExchange, exchangeShortName: exchangeShortName, price: price, description: description, industry: industry, ceo: ceo, sector: sector, country: country, fullTimeEmployees: fullTimeEmployees, phone: phone, address: address, city: city, state: state, zip: zip, website: website)
        }
    
    static func empty() -> Self {
        .init(symbol: "", image: "", companyName: "", currency: "", stockExchange: "", exchangeShortName: "", price: 0, description: "", industry: "", ceo: "", sector: "", country: "", fullTimeEmployees: "", phone: "", address: "", city: "", state: "", zip: "", website: "")
    }
}
