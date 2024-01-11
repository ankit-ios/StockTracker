//
//  StockUseCaseTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 11/01/24.
//

import XCTest
@testable import StockTracker

final class StockUseCaseTests: XCTestCase {
    
    static let stockList: [Stock] = [
        Stock.stub(symbol: "AY", name: "Atlantica Sustainable Infrastructure plc", currency: "USD", stockExchange: "NASDAQ Global Select", exchangeShortName: "NASDAQ"),
        Stock.stub(symbol: "AU", name: "AngloGold Ashanti Limited", currency: "USD", stockExchange: "New York Stock Exchange", exchangeShortName: "NYSE")
    ]
    
    
    // MARK: - StockList UseCase
    enum StockListRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class StockListRepositoryMock: StockListRepository {
        
        let result: Result<[Stock], Error>
        init(result: Result<[Stock], Error>) {
            self.result = result
        }
        
        func fetchStockList(completion: @escaping (Result<[Stock], Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
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
        let stockListRepositoryMock = StockListRepositoryMock(result: .success(StockUseCaseTests.stockList))
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
        let stockListRepositoryMock = StockListRepositoryMock(result: .success(StockUseCaseTests.stockList))
        let useCase = DefaultFetchStockListUseCase(respository: stockListRepositoryMock)
        
        _ = useCase.fetchStockList(completion: { result in
            if case let .success(list) = result {
                stockList = list
            }
        })
        XCTAssertTrue(stockList.first?.symbol == StockUseCaseTests.stockList.first?.symbol)
    }
    
    func test_fetchStockList_failure() {
        var stockList: [Stock] = []
        var failedFetchingError: Error?
        let stockListRepositoryMock = StockListRepositoryMock(result: .failure(StockListRepositorySuccessTestError.failedFetching))
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
    enum StockDetailRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class StockDetailRepositoryMock: StockDetailRepository {
        let result: Result<StockDetail, Error>
        init(result: Result<StockDetail, Error>) {
            self.result = result
        }
        
        func fetchStockDetail(symbol: String, completion: @escaping (Result<StockDetail, Error>) -> Void) -> Cancellable? {
            switch result {
            case .success(let detail):
                if detail.symbol == symbol {
                    completion(.success(detail))
                } else {
                    completion(.success(StockDetail.empty()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            return nil
        }
    }
    
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
        let stockListRepositoryMock = StockDetailRepositoryMock(result: .failure(StockDetailRepositorySuccessTestError.failedFetching))
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
}
