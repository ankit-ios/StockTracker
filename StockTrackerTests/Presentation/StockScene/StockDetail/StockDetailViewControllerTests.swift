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
    }
    
    func test_fetchStockDetail_failure() {
        viewModel = getViewModel(.init(result: .failure(StockDetailRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        self.sut.viewDidLoad()
    }
}
