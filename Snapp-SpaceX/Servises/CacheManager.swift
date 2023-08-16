//
//  ImageCache.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/10/23.
//
import SwiftUI
class CacheManager {
    static let shared = CacheManager()
    private init() {}
    private var imageCache : NSCache<NSString, UIImage> = {
       let cache = NSCache<NSString,UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func add(image: UIImage,name: String){
        imageCache.setObject(image, forKey: name as String as NSString)
    }
    
    func remove(name: String){
        imageCache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }

}
