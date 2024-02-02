//
//  StockLogoItem.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI

struct StockLogoItem: View {
    let title: String
    @Binding var image: UIImage?
    @Binding var downloadingState: ImageDownloadingState
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(AppFont.subtitle)
            Spacer()
            ImageView(
                image: $image,
                downloadingState: $downloadingState,
                placeholder: { ProgressView() } )
            .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    StockLogoItem(title: "Company Image", image: .constant(UIImage(systemName: "star.circle")), downloadingState: .constant(.done))
}
