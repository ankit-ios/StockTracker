//
//  DefaultNetworkSessionManager.swift
//  StockTracker
//
//  Created by Ankit Sharma on 25/01/24.
//

import Foundation

// MARK: - Certificate Pinning Constants
fileprivate struct CertConstants {
    static let serverHost = "financialmodelingprep.com"
    static let hostNameIdentifier = "financialmodelingprep"
    static let serverBaseURL = "https://financialmodelingprep.com"

    ///path of financialmodelingprep api server's certificate
    static var certificatePath: String? {
        Bundle.main.path(forResource: hostNameIdentifier, ofType: "cer")
    }
}


// MARK: - Default Network Session Manager
final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        let session = configureSession()
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }

    private func configureSession() -> URLSession {
        var configuration = URLSessionConfiguration.default
        
        // Load the server's certificate
        if let certificatePath = CertConstants.certificatePath,
           let serverCertificateData = try? Data(contentsOf: URL(fileURLWithPath: certificatePath)) {
            let pinnedCertificates = [serverCertificateData]
            
            // Create a policy that validates against the server's certificate
            let policy = SecPolicyCreateSSL(true, CertConstants.serverBaseURL as CFString)
            
            // Set the SSL configuration for the session
            configuration = URLSessionConfiguration.ephemeral
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            configuration.httpAdditionalHeaders = ["Accept": "application/json"]
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.urlCredentialStorage = nil
            configuration.httpShouldUsePipelining = false
            
            // Apply SSL pinning by setting the pinned certificates in the session's delegate
            let delegate = URLSessionPinningDelegate(pinnedCertificates: pinnedCertificates, serverHostname: CertConstants.serverHost)
            let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
            
            return session
        }
        
        return URLSession(configuration: configuration)
    }
}
