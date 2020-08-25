//
//  ImageDownloader.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//
import UIKit

final class ImageDownloader:NSObject {
    
    private static let imageUrlSession: URLSession = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        return URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: operationQueue)
    }()
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        imageUrlSession.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data,Error>) -> Void)
    {
        
        getData(url: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode < HTTPStatusCode.ok.rawValue || httpresponse.statusCode >= HTTPStatusCode.multipleChoices.rawValue {
                let error = NetworkError.other(string: HTTPStatusCode(statusCode: httpresponse.statusCode).statusDescription)
                completion(.failure(error))
                return
            }
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
}



