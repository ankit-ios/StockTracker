//
//  String+Extensions.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

extension String {
    
    func removeSpaces() -> Self {
        self.replacingOccurrences(of: " ", with: "")
    }
}
