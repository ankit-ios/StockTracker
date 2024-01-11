//
//  Endpoint.swift
//  StockTracker
//
//  Created by Ankit Sharma on 09/01/24.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

final class Endpoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let queryParameters: [String: Any]
    let queryParametersEncodable: Encodable?
    let responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         queryParameters: [String: Any] = [:],
         queryParametersEncodable: Encodable? = nil,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.queryParameters = queryParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.responseDecoder = responseDecoder
    }
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var queryParameters: [String: Any] { get }
    var queryParametersEncodable: Encodable? { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)

        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
