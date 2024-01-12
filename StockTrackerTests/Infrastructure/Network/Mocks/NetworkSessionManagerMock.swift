//
//  NetworkSessionManagerMock.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import Foundation
@testable import StockTracker

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSession.shared.dataTask(with: request)
    }
}
