//
//  StockReadMoreCell.swift
//  StockTracker
//
//  Created by Ankit Sharma on 05/01/24.
//

import UIKit

final class StockReadMoreCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StockReadMoreCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    var readMoreTapped: (() -> Void)?
    var isExpanded: Bool = false {
        didSet {
            updateDescriptionLabel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        readMoreButton.configuration?.contentInsets = .zero
        isExpanded = false
    }
    
    @objc private func readMoreButtonTapped() {
        readMoreTapped?()
    }
    
    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
        readMoreButton.setTitle(ReadMoreAttribute.readMore.title, for: .normal)
    }
}

private extension StockReadMoreCell {
    
    enum ReadMoreAttribute {
        case readMore
        case readLess
        
        var title: String {
            switch self {
            case .readMore: "Read more"
            case .readLess: "Read less"
            }
        }
        
        var numberOfLines: Int {
            switch self {
            case .readMore: 3
            case .readLess: 0
            }
        }
    }
    
    private func updateDescriptionLabel() {
        let attribute = isExpanded ? ReadMoreAttribute.readLess : .readMore
        valueLabel.numberOfLines = attribute.numberOfLines
        readMoreButton.setTitle(attribute.title, for: .normal)
    }
}

