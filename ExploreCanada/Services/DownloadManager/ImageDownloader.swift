//
//  ImageDownloader.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

public enum ResultImage<T> {
    case success(T)
    case failure(Error)
}

final class ImageDownloader: NSObject {
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func downloadImage(url: URL,
                                     completion: @escaping (ResultImage<Data>) -> Void)
    {
        
        ImageDownloader.getData(url: url) { data, response, error in
        
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }
    }
}

