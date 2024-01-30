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
        let viewModel = StockListViewModel(fetchStockListUseCase: useCase)
        
        viewModel.fetchStockList()
        
        let expectation = XCTestExpectation(description: "delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(viewModel.items.count, 2)
            XCTAssertEqual(viewModel.items.first?.symbol, "AY")
            XCTAssertTrue(viewModel.loadingState == .loaded)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_fetchStockList_failure() {
        let repository = StockListRepositoryMock(result: .failure(StockListRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = StockListViewModel(fetchStockListUseCase: useCase)
        
        XCTAssertTrue(viewModel.loadingState == .idle)
        viewModel.fetchStockList()
        
        let expectation = XCTestExpectation(description: "delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(viewModel.items.count, 0)
            XCTAssertTrue(viewModel.items.isEmpty)
            XCTAssertTrue(viewModel.loadingState == .error)
            XCTAssertFalse(viewModel.errorModel.message.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_didSelectItem_stockList() {
        let repository = StockListRepositoryMock(result: .success(Stock.mockData))
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = StockListViewModel(fetchStockListUseCase: useCase, actions: StockListViewModelActions(showStockDetail: showStockDetail))
        
        viewModel.fetchStockList()
        
        let expectation = XCTestExpectation(description: "delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            do {
                let stock = try XCTUnwrap(viewModel.items.first)
                viewModel.didSelectItem(stock.symbol)
            } catch {
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func showStockDetail(selectedStock: String) {
        print(selectedStock)
    }
}
