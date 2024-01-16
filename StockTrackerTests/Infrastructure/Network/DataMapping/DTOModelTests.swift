//
//  DTOModelTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

import XCTest
@testable import StockTracker

final class DTOModelTests: XCTestCase {
    
    func test_stockListDTO() {
        let stock = Stock.stub()
        let stockDTO = StockListDTO(symbol: stock.symbol, name: stock.name, currency: stock.currency, stockExchange: stock.stockExchange, exchangeShortName: stock.exchangeShortName)
        XCTAssertEqual(stock.symbol, stockDTO.toDomain().symbol)
    }
    
    func test_stockDetailResponseDTO() {
        let sd = StockDetail.stub()
        let stockDetailDTO = StockDetailResponseDTO(symbol: sd.symbol, image: nil, companyName: sd.companyName, currency: nil, stockExchange: nil, exchangeShortName: nil, price: nil, description: nil, industry: nil, ceo: nil, sector: nil, country: nil, fullTimeEmployees: nil, phone: nil, address: nil, city: nil, state: nil, zip: nil, website: nil)
        XCTAssertEqual(sd.symbol, stockDetailDTO.toDomain().symbol)
        XCTAssertEqual(sd.companyName, stockDetailDTO.toDomain().companyName)
    }
}
