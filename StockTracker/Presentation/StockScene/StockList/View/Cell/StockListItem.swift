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
            ForEach([
                (stock.symbol, AppFont.title),
                (stock.name, AppFont.caption),
                (stock.exchangeShortName ?? "", AppFont.subtitle),
                (stock.stockExchange ?? "", AppFont.caption)
            ], id: \.0) { text, font in
                Text(text)
                    .font(font)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.init(uiColor: AppColor.foregroundColor))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    StockListItem(stock: .init(symbol: "A", name: "Agilent Technologies, Inc.", currency: "USD", stockExchange: "New York Stock Exchange", exchangeShortName: "NYSE"))
}
