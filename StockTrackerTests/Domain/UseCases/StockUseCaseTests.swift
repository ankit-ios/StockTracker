//
//  StockUseCaseTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 11/01/24.
//

import XCTest
@testable import StockTracker

final class StockUseCaseTests: XCTestCase {
    
    // MARK: - StockList UseCase
    func test_fetchStockList_returnEmptyList() {
        var stockList: [Stock] = []
        let stockListRepositoryMock = StockListRepositoryMock(result: .success([]))
        let useCase = DefaultFetchStockListUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockList(completion: { result in
            if case let .success(list) = result {
                stockList = list
            }
        })
        XCTAssertTrue(stockList.isEmpty)
    }
    
    func test_fetchStockList_success() {
        var stockList: [Stock] = []
        let stockListRepositoryMock = StockListRepositoryMock(result: .success(Stock.mockData))
        let useCase = DefaultFetchStockListUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockList(completion: { result in
            if case let .success(list) = result {
                stockList = list
            }
        })
        XCTAssertTrue(stockList.count == 2)
    }
    
    func test_fetchStockList_validatingListItem() {
        var stockList: [Stock] = []
        let stockListRepositoryMock = StockListRepositoryMock(result: .success(Stock.mockData))
        let useCase = DefaultFetchStockListUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockList(completion: { result in
            if case let .success(list) = result {
                stockList = list
            }
        })
        XCTAssertTrue(stockList.first?.symbol == Stock.mockData.first?.symbol)
    }
    
    func test_fetchStockList_failure() {
        var stockList: [Stock] = []
        var failedFetchingError: Error?
        let stockListRepositoryMock = StockListRepositoryMock(result: .failure(StockListRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockListUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockList(completion: { result in
            switch result {
            case .success(let list):
                stockList = list
            case .failure(let error):
                failedFetchingError = error
            }
        })
        
        XCTAssertTrue(stockList.isEmpty)
        XCTAssertNotNil(failedFetchingError)
    }
    
    
    // MARK: - StockDetail UseCase
    func test_fetchStockDetail_returnEmpty() {
        var stockDetail: StockDetail?
        let stockListRepositoryMock = StockDetailRepositoryMock(result: .success(StockDetail.stub()))
        let useCase = DefaultFetchStockDetailUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockDetail(symbol: "A", completion: { result in
            if case let .success(detail) = result {
                stockDetail = detail
            }
        })
        XCTAssertNotNil(stockDetail)
        XCTAssertTrue(stockDetail!.symbol.isEmpty)
    }
    
    func test_fetchStockDetail_success() {
        var stockDetail: StockDetail?
        let stockListRepositoryMock = StockDetailRepositoryMock(result: .success(StockDetail.stub()))
        let useCase = DefaultFetchStockDetailUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockDetail(symbol: "AXL", completion: { result in
            if case let .success(detail) = result {
                stockDetail = detail
            }
        })
        XCTAssertNotNil(stockDetail)
        XCTAssertTrue(stockDetail!.symbol == "AXL")
    }
    
    func test_fetchStockDetail_failure() {
        var stockDetail: StockDetail?
        var failedFetchingError: Error?
        let stockListRepositoryMock = StockDetailRepositoryMock(result: .failure(StockDetailRepositoryMockError.failedFetching))
        let useCase = DefaultFetchStockDetailUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockDetail(symbol: "AXL", completion: { result in
            switch result {
            case .success(let detail):
                stockDetail = detail
            case .failure(let error):
                failedFetchingError = error
            }
        })
        XCTAssertNil(stockDetail)
        XCTAssertNotNil(failedFetchingError)
    }
    
    func test_fetchStockDetail_cancellingTask() {
        var stockDetail: StockDetail?
        var failedFetchingError: Error?
        let repositoryTask = RepositoryTask()
        
        let stockListRepositoryMock = StockDetailRepositoryMock(result: .failure(StockDetailRepositoryMockError.failedFetching), repositoryTask: repositoryTask)
        let useCase = DefaultFetchStockDetailUseCase(respository: stockListRepositoryMock)
        let stockDetailLoadTask: Cancellable?
        
        let expectation = XCTestExpectation(description: "Fetching stock detail")
        
        stockDetailLoadTask = useCase.fetchStockDetail(symbol: "AXL", completion: { result in
            switch result {
            case .success(let detail):
                stockDetail = detail
            case .failure(let error):
                failedFetchingError = error
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
        })
        stockDetailLoadTask?.cancel()
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNil(stockDetail)
        XCTAssertNotNil(failedFetchingError)
    }
}
