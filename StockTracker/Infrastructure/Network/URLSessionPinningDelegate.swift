//
//  URLSessionPinningDelegate.swift
//  StockTracker
//
//  Created by Ankit Sharma on 25/01/24.
//

import Foundation

// MARK: - URLSessionPinningDelegate
final class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    private let pinnedCertificates: [Data]
    private let serverHostname: String
    
    init(pinnedCertificates: [Data], serverHostname: String) {
        self.pinnedCertificates = pinnedCertificates
        self.serverHostname = serverHostname
    }
    
    
    /**
     Supporting SSL Pinning, but the code is commented out here. 
     - By bypassing the authentication challenge and trusting the certificate, we can handle cases where some stock APIs in certain networks might not work correctly and may throw errors.
     
     - If the `https://financialmodelingprep.com` URL works in your network, then SSL Pinning can be enabled by uncommenting the below code.
     */
    /**
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        ) -> Void
    ) {
        if let serverTrust = challenge.protectionSpace.serverTrust,
           let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
            let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
            if pinnedCertificates.contains(serverCertificateData) && challenge.protectionSpace.host == serverHostname {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
     */
    
    
    /// By bypassing the authentication challenge and trusting the certificate
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        ) -> Void
    ) {
        
        let protectionSpace = challenge.protectionSpace
        //Domain validation
        guard
            protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            protectionSpace.host.contains(serverHostname) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        guard let serverTrust = protectionSpace.serverTrust else {
            completionHandler(.useCredential, nil)
            return
        }
        
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
