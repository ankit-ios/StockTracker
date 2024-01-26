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
    private let unavailableViewImage = "chart.bar.xaxis.ascending"
    private var showError: Binding<Bool> {
        Binding(
            get: { viewModel.loadingState == .error },
            set: { _ in }
        )
    }
    
    init(viewModel: StockDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            getBody(for: viewModel.loadingState)
        }
        .showAlert(isPresented: showError, model: viewModel.errorModel)
        .listStyle(GroupedListStyle())
        .navigationBarTitle(viewModel.screenTitle, displayMode: .inline)
        .task {
            viewModel.fetchStockDetail()
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
            List {
                ForEach(viewModel.dataSource) { section in
                    Section(header: Text(section.title).font(AppFont.subtitle)) {
                        ForEach(section.items, id: \.title) { item in
                            createCellItem(item)
                        }
                    }
                }
            }
        case .error:
            ContentUnavailableView {
                Label(viewModel.titles.unavailableViewTitle, systemImage: unavailableViewImage)
            } description: {
                Text(viewModel.titles.unavailableViewDesc)
            }
        }
    }
    
    ///Returing Cell Item
    @ViewBuilder
    func createCellItem(_ item: StockDetailItemDataSource) -> some View {
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

#Preview {
    let container = DefaultStockSceneDIContainer(
        apiDataTransferService: DefaultAppDIContainer().apiDataTransferService,
        imageStorageService: DefaultImageResponseStorage()
    )
    
    return StockDetailView(
        viewModel:
            container.makeStockDetailViewModel(
                symbol: "A",
                actions: .init(dismissStockDetailVC: {})
            )
    )
}
