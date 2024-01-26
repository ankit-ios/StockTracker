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
    @State private var hasAppeared = false
    
    private let unavailableViewImage = "chart.bar.xaxis.ascending"
    private var showError: Binding<Bool> {
        Binding(
            get: { viewModel.loadingState == .error },
            set: { _ in }
        )
    }
    
    init(viewModel: StockListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                getBody(for: viewModel.loadingState)
            }
        }
        .showAlert(isPresented: showError, model: viewModel.errorModel)
        .navigationTitle(viewModel.titles.screenTitle)
        .task {
            guard !hasAppeared else { return }
            viewModel.fetchStockList()
            hasAppeared.toggle()
        }
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
            List(viewModel.items, id: \.symbol) { item in
                StockListItem(stock: item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.background)
                    .onTapGesture { viewModel.didSelectItem(item.symbol) }
            }
            .listStyle(.inset)
        case .error:
            ContentUnavailableView {
                Label(viewModel.titles.unavailableViewTitle, systemImage: unavailableViewImage)
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
    return StockListView(viewModel: container.makeStockListViewModel(actions: .init(showStockDetail: { symbol in
        print(symbol)
    })))
}
