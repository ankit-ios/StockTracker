//
//  AppConfigurations.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import Foundation

protocol AppConfiguration {
    var apiKey: String { get }
    var apiBaseURL: String { get }
}

final class DefaultAppConfiguration: AppConfiguration {
    
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}

