//
//  StockListCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

final class StockListCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StockListCell.self)
    
    @IBOutlet private weak var stockSymbolLabel: UILabel!
    @IBOutlet private weak var stockNameLabel: UILabel!
    @IBOutlet private weak var stockExchangeLabel: UILabel!
    @IBOutlet private weak var exchangeShortNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with stock: Stock) {
        stockSymbolLabel.text = stock.symbol
        stockNameLabel.text = stock.name
        stockExchangeLabel.text = stock.stockExchange
        exchangeShortNameLabel.text = stock.exchangeShortName
    }
}
