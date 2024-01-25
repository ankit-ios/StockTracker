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
    
    
    // MARK: - Image Download UseCase
    func test_downloadImage_returnNil() {
        var imageData: Data?
        var image: UIImage?
        let imageDownloadRepositoryMock = ImageDownloadRepositoryMock(result: .success(nil))
        let useCase = DefaultImageDownloadUseCase(respository: imageDownloadRepositoryMock)
        
        _ = useCase.fetchImage(with: "", completion: { result in
            if case let .success(data) = result {
                imageData = data
                if let data = data {
                    image = UIImage(data: data)
                }
            }
        })
        XCTAssertNil(imageData)
        XCTAssertNil(image)
    }
    
    func test_downloadImage_success() {
        var imageData: Data?
        var image: UIImage?
        let imageDownloadRepositoryMock = ImageDownloadRepositoryMock(result: .success(UIImage(systemName: "star.circle")?.pngData()))
        let useCase = DefaultImageDownloadUseCase(respository: imageDownloadRepositoryMock)
        
        _ = useCase.fetchImage(with: "", completion: { result in
            if case let .success(data) = result {
                imageData = data
                if let data = data {
                    image = UIImage(data: data)
                }
            }
        })
        XCTAssertNotNil(imageData)
        XCTAssertNotNil(image)
    }
    
    func test_downloadImage_failure() {
        var imageData: Data?
        var error: Error?
        let imageDownloadRepositoryMock = ImageDownloadRepositoryMock(result: .failure(ImageDownloadRepositoryMockError.failedDownloading))
        let useCase = DefaultImageDownloadUseCase(respository: imageDownloadRepositoryMock)
        
        _ = useCase.fetchImage(with: "", completion: { result in
            switch result {
            case .success(let data):
                imageData = data
            case .failure(let err):
                error = err
            }
        })
        XCTAssertNil(imageData)
        XCTAssertNotNil(error)
        XCTAssert(error as? ImageDownloadRepositoryMockError == .failedDownloading)
    }
    
    // MARK: - Image Caching UseCase
    func test_saveImage_returnImage() {
        var fetchedData: Data?
        let imageData = UIImage(systemName: "star.circle")?.pngData() ?? Data()
        let imageResponseStorage: ImageStorageService = DefaultImageResponseStorage()
        imageResponseStorage.cacheImage(imageData, forKey: "starCircle")
        
        imageResponseStorage.loadImage(from: "starCircle") { loadedImageData in
            fetchedData = loadedImageData
        }
        
        XCTAssertNotNil(fetchedData)
        XCTAssertNotNil(UIImage(data: fetchedData!))
    }
    
    func test_loadImageWithoutSaving_returnNil() {
        var fetchedData: Data?
        let imageResponseStorage: ImageStorageService = DefaultImageResponseStorage()
        
        imageResponseStorage.loadImage(from: "heart.fill") { loadedImageData in
            fetchedData = loadedImageData
        }
        XCTAssertNil(fetchedData)
    }
    
    func test_clearingCache_returnNil() {
        var fetchedDataBeforeClearing: Data?
        var fetchedDataAfterClearing1: Data?
        var fetchedDataAfterClearing2: Data?
        var fetchedDataAfterClearing3: Data?

        let imageData1 = UIImage(systemName: "heart.fill")?.pngData() ?? Data()
        let imageData2 = UIImage(systemName: "star.circle")?.pngData() ?? Data()
        let imageData3 = UIImage(systemName: "camera")?.pngData() ?? Data()

        let imageResponseStorage: ImageStorageService = DefaultImageResponseStorage()
        imageResponseStorage.cacheImage(imageData1, forKey: "heartFill")
        imageResponseStorage.cacheImage(imageData2, forKey: "starCircle")
        imageResponseStorage.cacheImage(imageData3, forKey: "camera")
        
        imageResponseStorage.loadImage(from: "heartFill") { loadedImageData in
            fetchedDataBeforeClearing = loadedImageData
        }
        
        imageResponseStorage.clearCache()
        
        imageResponseStorage.loadImage(from: "heartFill") { loadedImageData in
            fetchedDataAfterClearing1 = loadedImageData
        }
        imageResponseStorage.loadImage(from: "starCircle") { loadedImageData in
            fetchedDataAfterClearing2 = loadedImageData
        }
        imageResponseStorage.loadImage(from: "camera") { loadedImageData in
            fetchedDataAfterClearing3 = loadedImageData
        }
        
        XCTAssertNotNil(fetchedDataBeforeClearing)
        XCTAssertNil(fetchedDataAfterClearing1)
        XCTAssertNil(fetchedDataAfterClearing2)
        XCTAssertNil(fetchedDataAfterClearing3)
    }
}
