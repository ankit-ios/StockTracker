//
//  StockListViewControllerTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
@testable import StockTracker

final class StockListViewControllerTests: XCTestCase {
    
    private var sut: StockListViewController!
    private var viewModel: StockListViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func getViewModel(_ repository: StockListRepositoryMock) -> StockListViewModel {
        let useCase = DefaultFetchStockListUseCase(respository: repository)
        let viewModel = DefaultStockListViewModel(fetchStockListUseCase: useCase)
        return viewModel
    }
    
    func makeSUT(with viewModel: StockListViewModel) -> StockListViewController {
        let destination = StockListViewController.create(with: viewModel)
        destination.loadViewIfNeeded()
        return destination
    }
    
    func test_fetchStockList_success() {
        viewModel = getViewModel(.init(result: .success(Stock.mockData)))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
        _ = sut.view
    }
    
    func test_fetchStockList_failure() {
        viewModel = getViewModel(.init(result: .failure(StockListRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
        _ = sut.view
    }
}
