//
//  StockListView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI
import Combine

struct StockListView<VM: StockListViewModel>: View {
    
    @ObservedObject private var viewModel: VM
    @State private var hasAppeared = false
    @State private var selectedStockID: Stock.ID?
    
    private var showError: Binding<Bool> {
        Binding(
            get: { viewModel.loadingState == .error },
            set: { _ in }
        )
    }
    
    //We may also use the environment variable for data injection
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                getBody(for: viewModel.loadingState)
            }
        }
        .showAlert(isPresented: showError, model: viewModel.errorModel)
        .navigationTitle(viewModel.titles.screenTitle)
        .task {
            guard !hasAppeared else { return }
            viewModel.fetchStockList() //Could use the async-await for fetching StockList
            hasAppeared.toggle()
        }
        .onChange(of: selectedStockID, { _, _ in
            guard
                let selectedStockID = selectedStockID,
                let symbol = viewModel.items.first(where: { $0.id == selectedStockID })?.symbol else { return }
            viewModel.didSelectItem(symbol)
            self.selectedStockID = nil //This is removing background color for last selected ID
        })
    }
    
    ///Returing body based on LoadingState
    @ViewBuilder
    func getBody(for loadingState: LoadingState) -> some View {
        switch loadingState {
        case .idle: EmptyView()
        case .loading:
            ProgressView(viewModel.titles.loadingTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        case .loaded:
            //We may also use List here
            Table(viewModel.items, selection: $selectedStockID) {
                TableColumn("Stock") { stock in
                    StockListItem(stock: stock)
                }
            }
        case .error:
            ContentUnavailableView {
                Label(viewModel.titles.unavailableViewTitle, systemImage: ImageConstants.unavailable)
            } description: {
                Text(viewModel.titles.unavailableViewDesc)
            }
        }
    }
}

#Preview {
    let container = DefaultStockSceneDIContainer(
        apiDataTransferService: DefaultAppDIContainer().apiDataTransferService,
        imageStorageService: DefaultImageResponseStorage()
    )
    return StockListView<DefaultStockListViewModel>(viewModel: container.makeStockListViewModel(actions: .init(showStockDetail: { symbol in
        print(symbol)
    })) as! DefaultStockListViewModel)
}
