//
//  ReadMoreAttribute.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

enum ReadMoreAttribute {
    case readMore
    case readLess
    
    var title: String {
        switch self {
        case .readMore: "Read more"
        case .readLess: "Read less"
        }
    }
    
    var numberOfLines: Int? {
        switch self {
        case .readMore: 3
        case .readLess: nil
        }
    }
}
