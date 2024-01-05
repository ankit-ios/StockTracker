//
//  StockListCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

class StockListCell: UITableViewCell {
    
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockExchangeLabel: UILabel!
    @IBOutlet weak var exchangeShortNameLabel: UILabel!
    
    func configure(with stock: Stock) {
        stockSymbolLabel.text = stock.symbol
        stockNameLabel.text = stock.name
        stockExchangeLabel.text = stock.stockExchange
        exchangeShortNameLabel.text = stock.exchangeShortName
      }
}
