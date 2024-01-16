//
//  String+Extensions.swift
//  StockTracker
//
//  Created by Ankit Sharma on 16/01/24.
//

import Foundation

extension String {
    
    func isPhoneNumber() -> Bool {
        // Regex pattern for a simple phone number
        let phoneRegex = #"^\+?[0-9]{1,}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    func removeSpaces() -> Self {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func getURL() -> URL? {
        var url = ""
        if self.isPhoneNumber() {
            url = "tel://"
        }
        url.append(self)
        return .init(string: url)
    }
}
