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
            
            TextView(text: vm.description ?? "", config: DefaultTextViewConfig(vm.enableDataDetection))
                .font(AppFont.caption)
        }
    }
}

#Preview {
    StockDetailItem(vm: .init(title: "A", description: "https://developer.apple.com/documentation/uikit/uitextview/1618607-datadetectortypes", enableDataDetection: true))
}


