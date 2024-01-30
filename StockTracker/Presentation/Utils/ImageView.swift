//
//  ImageView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 26/01/24.
//

import SwiftUI

struct AsyncImageView: View {
    var imageUrl: String?

    var body: some View {
        Group {
            if let imageUrl = imageUrl,
                let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let loadedImage):
                        loadedImage
                            .resizable()
                    default:
                        errorView()
                    }
                }
            } else {
                errorView()
            }
        }
    }

    @ViewBuilder private func errorView() -> some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .resizable()
            .foregroundColor(.red)
            .padding()
    }
}
