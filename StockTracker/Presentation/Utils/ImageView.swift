//
//  ImageView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 26/01/24.
//

import SwiftUI

//We can also use the AsyncImage here
struct ImageView<P>: View where P : View {
    @Binding var image: UIImage?
    @Binding var downloadingState: ImageDownloadingState
    let placeholder: () -> P
    
    var body: some View {
        switch downloadingState {
        case .notStarted:
            EmptyView()
        case .inProgress:
            placeholder()
        case .done:
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                errorView()
            }
        case .error:
            errorView()
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        Image(systemName: ImageConstants.failedLogo)
            .resizable()
            .foregroundColor(.red)
            .padding()
    }
}
