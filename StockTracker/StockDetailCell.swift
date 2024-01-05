//
//  StockDetailCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

class StockDetailCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextView.textContainer.maximumNumberOfLines = 2
        valueTextView.textAlignment = .left
        valueTextView.isEditable = false
        valueTextView.isSelectable = true
        valueTextView.dataDetectorTypes = [.link, .phoneNumber]
    }
    
    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueTextView.text = value
    }
    
    func heightForCell(width: CGFloat) -> CGFloat {
        let titleSize = titleLabel.sizeThatFits(CGSize(width: width, height: .infinity))
        let valueSize = valueTextView.sizeThatFits(CGSize(width: width, height: .infinity))
        return max(titleSize.height, valueSize.height) + 20 // Add padding
    }
}
