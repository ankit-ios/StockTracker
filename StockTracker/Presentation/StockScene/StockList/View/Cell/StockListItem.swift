//
//  StockListItem.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI

struct StockListItem: View {
    
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stock.symbol)
                .font(AppFont.title)
            Text(stock.name)
                .font(AppFont.caption)
            Text(stock.exchangeShortName ?? "")
                .font(AppFont.subtitle)
            Text(stock.stockExchange ?? "")
                .font(AppFont.caption)
        }
    }
}

#Preview {
    StockListItem(stock: .init(symbol: "A", name: "Agilent Technologies, Inc.", currency: "USD", stockExchange: "New York Stock Exchange", exchangeShortName: "NYSE"))
}
