//
//  StockDetailItem.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI

struct StockDetailItem: View {
    
    private let vm: StockDetailItemViewModel
    
    init(vm: StockDetailItemViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(vm.title)
                .font(AppFont.subtitle)
            
            Spacer()
            
            if let description = vm.description,
               vm.enableDataDetection,
               let url = description.getURL() {
                Link(description, destination: url)
                    .font(AppFont.caption)
            } else {
                Text(vm.description ?? "")
                    .font(AppFont.caption)
            }
        }
    }
}

#Preview {
    StockDetailItem(vm: .init(title: "A", description: "https://developer.apple.com/documentation/uikit/uitextview/1618607-datadetectortypes", enableDataDetection: true))
}


