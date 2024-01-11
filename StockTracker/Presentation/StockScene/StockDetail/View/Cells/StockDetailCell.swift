//
//  StockDetailCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

final class StockDetailCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StockDetailCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextView.textContainer.maximumNumberOfLines = 2
        valueTextView.textAlignment = .left
        valueTextView.isEditable = false
        valueTextView.isSelectable = false
    }
    
    func configure(title: String, value: String?, enableDataDetection: Bool) {
        titleLabel.text = title
        valueTextView.text = value
        if enableDataDetection {
            valueTextView.isSelectable = true
            valueTextView.dataDetectorTypes = [.link, .phoneNumber]
        }
    }
    
    func heightForCell(width: CGFloat) -> CGFloat {
        let titleSize = titleLabel.sizeThatFits(CGSize(width: width, height: .infinity))
        let valueSize = valueTextView.sizeThatFits(CGSize(width: width, height: .infinity))
        return max(titleSize.height, valueSize.height) + 20 // Add padding
    }
}
