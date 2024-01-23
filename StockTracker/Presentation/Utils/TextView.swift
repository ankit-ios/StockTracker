//
//  TextView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 23/01/24.
//

import SwiftUI

/// Config protocol for TextView
protocol TextViewConfig {
    var textAlignment: NSTextAlignment { get }
    var maximumNumberOfLines: Int { get }
    var isEditable: Bool { get }
    var isSelectable: Bool { get }
    var isUserInteractionEnabled: Bool { get }
    var enableDataDetection: Bool { get }
    var dataDetectorTypes: UIDataDetectorTypes { get }
}

/// Custom TextView
struct TextView: UIViewRepresentable {
    
    var text: String
    var config: TextViewConfig
    
    init(text: String, config: TextViewConfig) {
        self.text = text
        self.config = config
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.textContainer.maximumNumberOfLines = config.maximumNumberOfLines
        textView.textAlignment = config.textAlignment
        textView.isEditable = config.isEditable
        textView.isSelectable = config.isSelectable
        textView.isUserInteractionEnabled = config.isUserInteractionEnabled
        textView.dataDetectorTypes = config.enableDataDetection ? config.dataDetectorTypes : []
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

/// Default Config for TextView
struct DefaultTextViewConfig: TextViewConfig {
    var textAlignment: NSTextAlignment = .right
    var maximumNumberOfLines: Int = 2
    var isEditable: Bool = false
    var isSelectable: Bool = true
    var isUserInteractionEnabled: Bool = true
    var enableDataDetection: Bool = false
    var dataDetectorTypes: UIDataDetectorTypes = [.link, .phoneNumber]
    
    init(_ enableDataDetection: Bool) {
        self.enableDataDetection = enableDataDetection
    }
}
