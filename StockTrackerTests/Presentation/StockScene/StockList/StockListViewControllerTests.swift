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
        
        let expectation = XCTestExpectation(description: "Table view reloads")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetchStockList_failure() {
        viewModel = getViewModel(.init(result: .failure(StockListRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
        _ = sut.view
    }
    
    func test_fetchStockListCells_success() {
        let stub = Stock.stub()
        let tableView = UITableView()
        let nib = UINib(nibName: StockListCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: StockListCell.reuseIdentifier)
        
        let stockListCell = tableView.dequeueReusableCell(withIdentifier: StockListCell.reuseIdentifier) as? StockListCell
        stockListCell?.configure(with: stub)
    }
}
