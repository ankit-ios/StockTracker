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
        
        let viewModel = StockDetailViewModel(symbol: StockDetail.stub().symbol, fetchStockDetailUseCase: useCase, imageDownloadUseCase: imageDownloadUseCase)
        
        viewModel.fetchStockDetail()
        viewModel.downloadImage(for: "https://financialmodelingprep.com/image-stock/AXL.png")
        
        let expectation = XCTestExpectation(description: "delay")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(viewModel.stockLogoImage)
            XCTAssertFalse(viewModel.dataSource.isEmpty)
            XCTAssertFalse(viewModel.showError)
            XCTAssertTrue(viewModel.errorModel.message.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_fetchStockDetail_failure() {
        let repository = StockDetailRepositoryMock(result: .failure(StockDetailRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockDetailUseCase(respository: repository)
        let imageDownloadRepository = ImageDownloadRepositoryMock(result: .success(Data()))
        let imageDownloadUseCase = DefaultImageDownloadUseCase(respository: imageDownloadRepository)
        
        let viewModel = StockDetailViewModel(symbol: "", fetchStockDetailUseCase: useCase, imageDownloadUseCase: imageDownloadUseCase)
        
        viewModel.fetchStockDetail()
        viewModel.downloadImage(for: "https://financialmodelingprep.com/image-stock/AXL.png")
        
        let expectation = XCTestExpectation(description: "delay")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNil(viewModel.stockLogoImage)
            XCTAssertTrue(viewModel.dataSource.isEmpty)
            XCTAssertTrue(viewModel.showError)
            XCTAssertFalse(viewModel.errorModel.message.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_readMoreLess_attribute() {
        
        let readMoreAttribute = ReadMoreAttribute.readMore
        XCTAssertEqual(readMoreAttribute.title, "Read more")
        XCTAssertEqual(readMoreAttribute.numberOfLines, 3)
        
        let readLessAttribute = ReadMoreAttribute.readLess
        XCTAssertEqual(readLessAttribute.title, "Read less")
        XCTAssertNil(readLessAttribute.numberOfLines)
    }
    
    func test_stringExtensions() {
        let str = "Read less Read more "
        XCTAssertEqual(str.removeSpaces(), "ReadlessReadmore")
    }
}
