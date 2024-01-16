//
//  StockListViewControllerTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
import SwiftUI
@testable import StockTracker

final class StockListViewTests: XCTestCase {
    
    private var sut: StockListView!
    private var viewModel: StockListViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func getViewModel(_ repository: StockListRepositoryMock) -> StockListViewModel {
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = StockListViewModel(fetchStockListUseCase: useCase)
        return viewModel
    }
    
    func makeSUT(with viewModel: StockListViewModel) -> StockListView {
        return StockListView(viewModel: viewModel)
    }
    
    func test_fetchStockList_success() {
        viewModel = getViewModel(.init(result: .success(Stock.mockData)))
        self.sut = self.makeSUT(with: viewModel)
        XCTAssertNotNil(sut.body)
    }
    
    func test_fetchStockList_failure() {
        viewModel = getViewModel(.init(result: .failure(StockListRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        XCTAssertNotNil(sut.body)
    }
    
    func test_fetchStockListCells_success() throws {
        let stub = Stock.stub()
        
        let listItem = StockListItem(stock: stub)
        let cellView = try XCTUnwrap(listItem)
        XCTAssertNotNil(cellView.body)
    }
}
