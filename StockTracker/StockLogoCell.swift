//
//  StockLogoCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 05/01/24.
//

import UIKit

class StockLogoCell: UITableViewCell {
    
    @IBOutlet weak var logoTitleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    func configure(with title: String, logoUrl: String?) {
        logoTitleLabel.text = title
        if let logoUrl = logoUrl {
            ImageDownloader.shared.loadImage(from: logoUrl, completion: { image in
                DispatchQueue.main.async {
                    self.logoImageView.image = image
                }
            })
        }
    }
}
