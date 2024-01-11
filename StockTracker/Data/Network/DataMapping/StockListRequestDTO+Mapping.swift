//
//  StockListRequestDTO+Mapping.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

struct StockListRequestDTO: Encodable {
    let query: String
    let currency: String
    let limit: Int
}
