//
//  StockDetailView.swift
//  StockTracker
//
//  Created by Ankit Sharma on 15/01/24.
//

import SwiftUI
import Combine

struct StockDetailView<VM: StockDetailViewModel>: View {
    
    @ObservedObject private var viewModel: VM
    private var showError: Binding<Bool> {
        Binding(
            get: { viewModel.loadingState == .error || viewModel.imageDownloadingState == .error },
            set: { _ in }
        )
    }
    
    //We may also use the environment variable for data injection
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            getBody(for: viewModel.loadingState)
        }
        .showAlert(isPresented: showError, model: viewModel.errorModel)
        .listStyle(GroupedListStyle())
        .navigationBarTitle(viewModel.screenTitle, displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: createLeftBarItem)
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
                Label(viewModel.titles.unavailableViewTitle, systemImage: ImageConstants.unavailable)
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
            StockLogoItem(title: item.title, image: $viewModel.stockLogoImage, downloadingState: $viewModel.imageDownloadingState)
                .onAppear {
                    viewModel.downloadImage(for: item.description)
                }
        }
    }
    
    ///Returing ToolbarContent (Back button item)
    func createLeftBarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading, content: {
            //Back button
            Button {
                viewModel.dismiss()
            } label: {
                Image(systemName: ImageConstants.back)
            }
            .foregroundColor(.init(uiColor: AppColor.foregroundColor))
        })
    }
}

#Preview {
    let container = DefaultStockSceneDIContainer(
        apiDataTransferService: DefaultAppDIContainer().apiDataTransferService,
        imageStorageService: DefaultImageResponseStorage()
    )
    
    return StockDetailView<DefaultStockDetailViewModel>(
        viewModel:
            container.makeStockDetailViewModel(
                symbol: "A",
                actions: .init(dismissStockDetailVC: {})
            ) as! DefaultStockDetailViewModel
    )
}
