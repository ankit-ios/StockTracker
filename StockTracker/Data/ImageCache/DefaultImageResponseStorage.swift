//
//  DefaultImageResponseStorage.swift
//  StockTracker
//
//  Created by Ankit Sharma on 11/01/24.
//

import Foundation

final class DefaultImageResponseStorage: ImageResponseStorage {
    
    private let imageCache = NSCache<NSString, NSData>()

    func loadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        if let cachedImageData = imageCache.object(forKey: urlString as NSString) as Data? {
            completion(cachedImageData)
        } else {
            completion(nil)
        }
    }
    
    func cacheImage(_ data: Data, forKey key: String) {
        imageCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
}

