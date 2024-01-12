//
//  StockListViewModelTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
@testable import StockTracker

final class StockListViewModelTests: XCTestCase {    
    
    func test_fetchStockList_success() {
        let repository = StockListRepositoryMock(result: .success(Stock.mockData))
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = DefaultStockListViewModel(fetchStockListUseCase: useCase)

        viewModel.fetchStockList()
        
        XCTAssertEqual(viewModel.items.value.count, 2)
        XCTAssertEqual(viewModel.items.value.first?.symbol, "AY")
        XCTAssertTrue(viewModel.error.value.isEmpty)
        XCTAssertFalse(viewModel.errorTitle.isEmpty)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_fetchStockList_failure() {
        let repository = StockListRepositoryMock(result: .failure(StockListRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = DefaultStockListViewModel(fetchStockListUseCase: useCase)

        viewModel.fetchStockList()
        
        XCTAssertEqual(viewModel.items.value.count, 0)
        XCTAssertTrue(viewModel.items.value.isEmpty)
        XCTAssertFalse(viewModel.error.value.isEmpty)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_didSelectItem_stockList() {
        let repository = StockListRepositoryMock(result: .success(Stock.mockData))
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = DefaultStockListViewModel(fetchStockListUseCase: useCase, actions: StockListViewModelActions(showStockDetail: showStockDetail))

        viewModel.fetchStockList()
        viewModel.didSelectItem(at: 0)
        
        XCTAssertFalse(viewModel.items.value.isEmpty)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func showStockDetail(selectedStock: String) {
        print(selectedStock)
    }
}
