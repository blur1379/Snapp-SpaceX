//
//  ImageCache.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//

import SwiftUI

// MARK: - Cache Manager
/// An actor that manages caching of UIImage objects.
actor CacheManager {
    // Shared instance of the cache manager for convenient access.
    static let shared = CacheManager()
    private init() {}
    
    // NSCache instance used for caching UIImage objects.
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    /// Adds an image to the cache with a specified name.
    ///
    /// - Parameters:
    ///   - image: The UIImage to be cached.
    ///   - name: The unique identifier for the image in the cache.
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    /// Removes an image from the cache with a specified name.
    ///
    /// - Parameter name: The unique identifier for the image in the cache.
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
    
    /// Retrieves an image from the cache with a specified name.
    ///
    /// - Parameter name: The unique identifier for the image in the cache.
    /// - Returns: The cached UIImage, or `nil` if not found.
    func get(name: String) -> UIImage? {
        imageCache.object(forKey: name as NSString)
    }
}
