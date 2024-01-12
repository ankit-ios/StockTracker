//
//  StockDetailViewControllerTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
@testable import StockTracker

final class StockDetailViewControllerTests: XCTestCase {
    
    private var sut: StockDetailViewController!
    private var viewModel: StockDetailViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func getViewModel(_ repository: StockDetailRepositoryMock) -> StockDetailViewModel {
        let useCase = DefaultFetchStockDetailUseCase(respository: repository)
        let imageDownloadRepository = ImageDownloadRepositoryMock(result: .success(UIImage(systemName: "star.circle")?.pngData()))
        let imageDownloadUseCase = DefaultImageDownloadUseCase(respository: imageDownloadRepository)
        let viewModel = DefaultStockDetailViewModel(symbol: StockDetail.stub().symbol, fetchStockDetailUseCase: useCase, imageDownloadUseCase: imageDownloadUseCase)
        return viewModel
    }
    
    func makeSUT(with viewModel: StockDetailViewModel) -> StockDetailViewController {
        let destination = StockDetailViewController.create(with: viewModel)
        destination.loadViewIfNeeded()
        return destination
    }
    
    func test_fetchStockDetail_success() {
        viewModel = getViewModel(.init(result: .success(StockDetail.stub())))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
        _ = sut.view
        
        let expectation = XCTestExpectation(description: "Table view reloads")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetchStockDetail_failure() {
        viewModel = getViewModel(.init(result: .failure(StockDetailRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
        _ = sut.view
    }
    
    func test_fetchStockDetailCells_success() {
        let stub = StockDetail.stub()
        
        let tableView = UITableView()
        let cellIdentifiers = [StockDetailCell.reuseIdentifier, StockLogoCell.reuseIdentifier, StockReadMoreCell.reuseIdentifier]
        cellIdentifiers.forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: $0)
        }

        let stockLogoCell = tableView.dequeueReusableCell(withIdentifier: StockLogoCell.reuseIdentifier) as? StockLogoCell
        stockLogoCell?.configure(with: "Image")
        stockLogoCell?.updateLogo(with: UIImage(systemName: "star.circle"))
        
        let stockReadMoreCell = tableView.dequeueReusableCell(withIdentifier: StockReadMoreCell.reuseIdentifier) as? StockReadMoreCell
        stockReadMoreCell?.configure(title: "Description", value: stub.description)
        stockReadMoreCell?.isExpanded = true
        
        let stockDetailCell = tableView.dequeueReusableCell(withIdentifier: StockDetailCell.reuseIdentifier) as? StockDetailCell
        stockDetailCell?.configure(title: "Company Name", value: stub.companyName, enableDataDetection: false)
        stockDetailCell?.configure(title: "Website", value: stub.website, enableDataDetection: true)
    }
}
