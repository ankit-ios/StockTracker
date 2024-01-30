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
    let placeholder: () -> P

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder()
        }
    }
}
