//
//  ImageView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 26/01/24.
//

import SwiftUI

struct ImageView: View {
    @Binding var image: UIImage?

    var body: some View {
        if let loadedImage = image {
            Image(uiImage: loadedImage)
                .resizable()
        } else {
            ProgressView()
        }
    }
}
