//
//  APIEndpoints.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

struct APIEndpoints {
    
    static func getStockList(with stockListDTO: StockListRequestDTO) -> Endpoint<[StockListDTO]> {
        return Endpoint(
            path: "search",
            method: .get,
            queryParametersEncodable: stockListDTO
        )
    }
    
    static func getStockDetail(with symbol: String, stockDetailDTO: StockDetailRequestDTO) -> Endpoint<[StockDetailResponseDTO]> {
        return Endpoint(
            path: "profile/\(symbol)",
            method: .get,
            queryParametersEncodable: stockDetailDTO
        )
    }
}
