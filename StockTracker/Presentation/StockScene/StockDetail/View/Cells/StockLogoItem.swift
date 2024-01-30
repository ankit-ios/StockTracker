//
//  StockLogoItem.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI

struct StockLogoItem: View {
    let title: String
    var imageUrl: String?
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(AppFont.subtitle)
            Spacer()
           
            AsyncImageView(imageUrl: imageUrl)
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    StockLogoItem(title: "Company Image", imageUrl: "https://financialmodelingprep.com/image-stock/AXL.png")
}
