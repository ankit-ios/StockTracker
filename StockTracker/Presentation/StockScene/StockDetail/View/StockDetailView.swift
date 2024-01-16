//
//  StockDetailView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI
import Combine

struct StockDetailView: View {
    
    @ObservedObject private var viewModel: StockDetailViewModel
    
    init(viewModel: StockDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                
                //List
                List {
                    ForEach(viewModel.dataSource) { section in
                        Section(header: Text(section.title).font(AppFont.subtitle)) {
                            ForEach(section.items, id: \.title) { item in
                                switch(item.cellType) {
                                case .textCell:
                                    StockDetailItem(vm: .init(title: item.title, description: item.description, enableDataDetection: item.enableDataDetection))
                                case .readMoreCell:
                                    StockDetailReadMoreItem(vm: .init(title: item.title, description: item.description))
                                case .imageCell:
                                    StockLogoItem(title: item.title, image: $viewModel.stockLogoImage)
                                        .onAppear {
                                            viewModel.downloadImage(for: item.description)
                                        }
                                }
                            }
                        }
                    }
                }
                .onAppear(perform: {
                    viewModel.fetchStockDetail()
                })
                .showAlert(isPresented: $viewModel.showError, model: .init(title: viewModel.errorModel.title, message: $viewModel.errorModel.message))
                .listStyle(GroupedListStyle())
                .navigationBarTitle(viewModel.screenTitle, displayMode: .inline)
                
                //Loading View
                if viewModel.loadingData {
                    ProgressView(viewModel.loadingTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                }
            }
        }
    }
}

#Preview {
    StockDetailView(
        viewModel:
            (UIApplication.shared.delegate as! AppDelegate)
            .appDIContainer
            .makeStockSceneDIContainer()
            .makeStockDetailViewModel(symbol: "A",
                                      actions: .init(dismissStockDetailVC: { }))
    )
}
