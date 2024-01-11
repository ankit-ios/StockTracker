//
//  StockLogoCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 05/01/24.
//

import UIKit

final class StockLogoCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StockLogoCell.self)
    static let cellHeight = 170.0

    @IBOutlet private weak var logoTitleLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    
    func configure(with title: String) {
        logoTitleLabel.text = title
    }
    
    func updateLogo(with image: UIImage?) {
        logoImageView.image = image
    }
}
