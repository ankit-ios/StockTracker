//
//  StockDetailReadMoreItem.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI

struct StockDetailReadMoreItem: View {
    
    let vm: StockDetailItemViewModel
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(vm.title)
                .font(AppFont.subtitle)
            
            let attribute = isExpanded ? ReadMoreAttribute.readLess : .readMore
            Text(vm.description ?? "")
                .font(AppFont.caption)
                .lineLimit(attribute.numberOfLines)
            
            Button(attribute.title) {
                withAnimation(.default) {
                    isExpanded.toggle()
                }
            }
            .font(AppFont.caption)
        }
    }
}

#Preview {
    StockDetailReadMoreItem(vm: .init(title: "A", description: "American Axle & Manufacturing Holdings, Inc., together with its subsidiaries, designs, engineers, and manufactures driveline and metal forming technologies that supports electric, hybrid, and internal combustion vehicles in the United States, Mexico, South America, China, other Asian countries, and Europe.", enableDataDetection: true))
}
