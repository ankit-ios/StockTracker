//
//  StockDetailViewModelTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
@testable import StockTracker

final class StockDetailViewModelTests: XCTestCase {
    
    func test_fetchStockDetail_success() {
        let repository = StockDetailRepositoryMock(result: .success(StockDetail.stub()))
        let useCase = DefaultFetchStockDetailUseCase(respository: repository)
        let imageDownloadRepository = ImageDownloadRepositoryMock(result: .success(UIImage(systemName: "star.circle")?.pngData()))
        let imageDownloadUseCase = DefaultImageDownloadUseCase(respository: imageDownloadRepository)
        
        let viewModel = DefaultStockDetailViewModel(symbol: StockDetail.stub().symbol, fetchStockDetailUseCase: useCase, imageDownloadUseCase: imageDownloadUseCase)
        
        viewModel.fetchStockDetail()
        viewModel.downloadStockLogo()
        
        XCTAssertNotNil(viewModel.stockDetail.value)
        XCTAssertNotNil(viewModel.stockLogo.value)
        XCTAssertFalse(viewModel.sections.isEmpty)
        XCTAssertFalse(viewModel.dataSource.isEmpty)
        XCTAssertTrue(viewModel.error.value.isEmpty)
    }
    
    func test_fetchStockDetail_failure() {
        let repository = StockDetailRepositoryMock(result: .failure(StockDetailRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockDetailUseCase(respository: repository)
        let imageDownloadRepository = ImageDownloadRepositoryMock(result: .success(Data()))
        let imageDownloadUseCase = DefaultImageDownloadUseCase(respository: imageDownloadRepository)
        
        let viewModel = DefaultStockDetailViewModel(symbol: "", fetchStockDetailUseCase: useCase, imageDownloadUseCase: imageDownloadUseCase)
        
        viewModel.fetchStockDetail()
        viewModel.downloadStockLogo()
        
        XCTAssertNil(viewModel.stockDetail.value)
        XCTAssertNil(viewModel.stockLogo.value)
        XCTAssertFalse(viewModel.sections.isEmpty)
        XCTAssertFalse(viewModel.dataSource.isEmpty)
        XCTAssertFalse(viewModel.error.value.isEmpty)
    }
}
