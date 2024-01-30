//
//  StockDetailViewControllerTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
import SwiftUI
@testable import StockTracker

final class StockDetailViewControllerTests: XCTestCase {
    
    private var sut: StockDetailView!
    private var viewModel: StockDetailViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func getViewModel(_ repository: StockDetailRepositoryMock) -> StockDetailViewModel {
        let useCase = DefaultFetchStockDetailUseCase(respository: repository)
        let viewModel = StockDetailViewModel(symbol: StockDetail.stub().symbol, fetchStockDetailUseCase: useCase)
        return viewModel
    }
    
    func makeSUT(with viewModel: StockDetailViewModel) -> StockDetailView {
        return StockDetailView(viewModel: viewModel)
    }
    
    func test_fetchStockDetail_success() {
        viewModel = getViewModel(.init(result: .success(StockDetail.stub())))
        self.sut = self.makeSUT(with: viewModel)
        XCTAssertNotNil(sut.body)
    }
    
    func test_fetchStockDetail_failure() {
        viewModel = getViewModel(.init(result: .failure(StockDetailRepositoryMockError.failedFetching)))
        self.sut = self.makeSUT(with: viewModel)
        XCTAssertNotNil(sut.body)
    }
    
    func test_fetchStockDetailCells_success() throws {
        let logoItem = StockLogoItem(title: "Test Logo", imageUrl: "https://financialmodelingprep.com/image-stock/AXL.png")
        let detailItem1 = StockDetailItem(vm: .init(title: "Company Name", description: "American Axle & Manufacturing Holdings, Inc.", enableDataDetection: false))
        let detailItem2 = StockDetailItem(vm: .init(title: "Website", description: "https://www.aam.com", enableDataDetection: true))
        let detailItem3 = StockDetailItem(vm: .init(title: "Mobile", description: "313 758 2000", enableDataDetection: true))
        
        let readMoreItem = StockDetailReadMoreItem.init(vm: .init(title: "Description", description: "American Axle & Manufacturing Holdings, Inc., together with its subsidiaries, designs, engineers, and manufactures driveline and metal forming technologies that supports electric, hybrid, and internal combustion vehicles in the United States, Mexico, South America, China, other Asian countries, and Europe.", enableDataDetection: false))
        
        try ([logoItem, detailItem1, detailItem2, detailItem3, readMoreItem] as? [any View])?
            .forEach { cell in
                let cellView = try XCTUnwrap(cell)
                XCTAssertNotNil(cellView.body)
            }
    }
}
