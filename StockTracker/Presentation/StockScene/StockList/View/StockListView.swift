//
//  StockListView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI
import Combine

struct StockListView: View {
    
    @ObservedObject private var viewModel: StockListViewModel
    @State private var dataLoaded = false
    
    init(viewModel: StockListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //List
                List {
                    ForEach(viewModel.items, id: \.symbol) { item in
                        StockListItem(stock: item)
                            .onTapGesture { viewModel.didSelectItem(item.symbol) }
                    }
                }
                .listStyle(.inset)
                
                //Loading View
                if viewModel.loadingData {
                    ProgressView(viewModel.loadingTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                }
            }
        }
        .showAlert(isPresented: $viewModel.showError, model: .init(title: viewModel.errorModel.title, message: $viewModel.errorModel.message))
        .navigationTitle(viewModel.screenTitle)
        .onAppear(perform: {
            if !dataLoaded {
                viewModel.fetchStockList()
                dataLoaded = true
            }
        })
    }
}

#Preview {
    let container = DefaultStockSceneDIContainer(
        apiDataTransferService: DefaultAppDIContainer().apiDataTransferService,
        imageStorageService: DefaultImageResponseStorage()
    )
    return StockListView(viewModel: container.makeStockListViewModel(actions: .init(showStockDetail: { symbol in
        print(symbol)
    })))
}
