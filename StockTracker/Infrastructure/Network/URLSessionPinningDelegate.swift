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
}
