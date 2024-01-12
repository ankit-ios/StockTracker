//
//  NetworkServiceTests.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import XCTest
@testable import StockTracker

final class NetworkServiceTests: XCTestCase {
    
    static let stockList: [Stock] = [
        Stock.stub(symbol: "AY", name: "Atlantica Sustainable Infrastructure plc", currency: "USD", stockExchange: "NASDAQ Global Select", exchangeShortName: "NASDAQ"),
        Stock.stub(symbol: "AU", name: "AngloGold Ashanti Limited", currency: "USD", stockExchange: "New York Stock Exchange", exchangeShortName: "NYSE")
    ]
    
    static let mockURL = "http://mock.test.com"
    
    
    private struct EndpointMock: Requestable {
        var path: String
        var isFullPath: Bool = false
        var method: HTTPMethodType
        var headerParameters: [String: String] = [:]
        var queryParametersEncodable: Encodable?
        var queryParameters: [String: Any] = [:]
        var bodyParametersEncodable: Encodable?
        var bodyParameters: [String: Any] = [:]
        
        init(path: String, method: HTTPMethodType) {
            self.path = path
            self.method = method
        }
    }
    
    class NetworkErrorLoggerMock: NetworkErrorLogger {
        var loggedErrors: [Error] = []
        func log(request: URLRequest) { }
        func log(responseData data: Data?, response: URLResponse?) { }
        func log(error: Error) { loggedErrors.append(error) }
    }
    
    private enum NetworkErrorMock: Error {
        case someError
    }
    
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: expectedResponseData,
                error: nil
            )
        )
        //when
        _ = sut.request(endpoint: EndpointMock(path: NetworkServiceTests.mockURL, method: .get)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            completionCallsCount += 1
        }
        //then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil, data: nil, error: cancelledError as Error))
        //when
        _ = sut.request(endpoint: EndpointMock(path: NetworkServiceTests.mockURL, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }
                
                completionCallsCount += 1
            }
        }
        //then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: response,
                                                                                  data: nil,
                                                                                  error: NetworkErrorMock.someError))
        //when
        _ = sut.request(endpoint: EndpointMock(path: NetworkServiceTests.mockURL, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.error(let statusCode, _) = error {
                    XCTAssertEqual(statusCode, 500)
                    completionCallsCount += 1
                }
            }
        }
        //then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: nil,
                                                                                  error: error as Error))
        
        //when
        _ = sut.request(endpoint: EndpointMock(path: NetworkServiceTests.mockURL, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                
                completionCallsCount += 1
            }
        }
        //then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        //when
        let notConnectedSut = NetworkError.notConnected
        let urlGenerationSut = NetworkError.urlGeneration
        let isNotFoundSut = NetworkError.error(statusCode: 404, data: nil)
        
        //then
        XCTAssertFalse(notConnectedSut.hasStatusCode(200))
        XCTAssertFalse(urlGenerationSut.hasStatusCode(200))
        XCTAssertTrue(isNotFoundSut.isNotFoundError)
    }
    
    func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode_() {
        //when
        let sut = NetworkError.error(statusCode: 400, data: nil)
        //then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldLogThisError() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkErrorLogger = NetworkErrorLoggerMock()
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: nil,
                                                                                  error: error as Error),
                                        logger: networkErrorLogger)
        //when
        _ = sut.request(endpoint: EndpointMock(path: NetworkServiceTests.mockURL, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                
                completionCallsCount += 1
            }
        }
        
        //then
        printIfDebug("completionCallsCount: \(completionCallsCount)")
        XCTAssertEqual(completionCallsCount, 1)
        XCTAssertTrue(networkErrorLogger.loggedErrors.contains {
            guard case NetworkError.notConnected = $0 else { return false }
            return true
        })
    }
}
