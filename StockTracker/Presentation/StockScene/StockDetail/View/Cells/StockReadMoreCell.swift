//
//  StockReadMoreCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 05/01/24.
//

import UIKit

class StockReadMoreCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    var readMoreTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        valueLabel.numberOfLines = 3
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        
        readMoreButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    @objc private func readMoreButtonTapped() {
        readMoreTapped?()
    }

    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
        updateButtonTitle()
    }
    
    func updateButtonTitle() {
        let buttonTitle = valueLabel.numberOfLines == 3 ? "Read more" : "Read less"
        readMoreButton.setTitle(buttonTitle, for: .normal)
    }
}

