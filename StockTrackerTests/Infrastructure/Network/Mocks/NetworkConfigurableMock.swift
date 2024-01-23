//
//  NetworkConfigurableMock.swift
//  StockTrackerTests
//
//  Created by Ankit Sharma on 12/01/24.
//

import Foundation
@testable import StockTracker

final class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
