//
//  ImageResponseStorage.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation

protocol ImageStorageService {
    func loadImage(from urlString: String, completion: @escaping (Data?) -> Void)
    func cacheImage(_ data: Data, forKey key: String)
    func clearCache()
}
