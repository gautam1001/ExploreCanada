//
//  HTTPRequestManager.swift
//
//  Created by Prashant Gautam on 19/03/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

 class HTTPRequestManager: NSObject{
    
    fileprivate lazy var urlSession: URLSession = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        return URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: operationQueue)
    }()
    
    // This will hold the currently running requests
    fileprivate var runningURLRequests: NSSet = NSSet()
    
    // MARK: - Singleton Instance
    class var shared: HTTPRequestManager {
        struct Singleton {
            static let instance = HTTPRequestManager()
        }
        return Singleton.instance
    }
    
    private override init() {}
    // MARK: - Public Methods
    
    /**
     Perform request to fetch data
     
     - parameter request:           url request
     - parameter completionHandler: handler
     */
    func performRequest(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) {
        guard isNetworkAvaiblable() else {
            let response = Response(request, nil, nil, error: NetworkError.reachability)
            completionHandler(response)
            return // do not proceed if user  is not connected to internet
        }
        dataTaskWithRequest(request, completionHandler: completionHandler)
    }
    
    /**
     Perform session data task
     
     - parameter request:           url request
     - parameter completionHandler: completion handler
     */
    private func dataTaskWithRequest(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) {
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            var apiResponse: Response
            apiResponse = Response(request, response as? HTTPURLResponse, data, error: error)
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(apiResponse)
            })
        }).resume()
    }
}

// MARK: - Request handling methods

extension HTTPRequestManager {
    
    /**
     Cancel session for a URL.
     
     - parameter url: URL
     */
    func cancelRequestForURL(_ url: URL) {
        urlSession.getTasksWithCompletionHandler({ (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in
            
            let capacity: NSInteger = dataTasks.count + uploadTasks.count + downloadTasks.count
            let tasks: NSMutableArray = NSMutableArray(capacity: capacity)
            tasks.addObjects(from: dataTasks)
            tasks.addObjects(from: uploadTasks)
            tasks.addObjects(from: downloadTasks)
            
            let predicate: NSPredicate = NSPredicate(format: "originalRequest.URL.path = %@", url.path as CVarArg)
            tasks.filter(using: predicate)
            
            for task in tasks {
                (task as? URLSessionTask)?.cancel()
            }
        })
    }
    
    /**
     Cancel All Running Requests
     */
    func cancelAllRequests() {
        urlSession.getTasksWithCompletionHandler({ (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in
            
            let capacity: NSInteger = dataTasks.count + uploadTasks.count + downloadTasks.count
            let tasks: NSMutableArray = NSMutableArray(capacity: capacity)
            tasks.addObjects(from: dataTasks)
            tasks.addObjects(from: uploadTasks)
            tasks.addObjects(from: downloadTasks)
            
            for task in tasks {
                (task as? URLSessionTask)?.cancel()
            }
        })
    }
    
    /// Check for network availability
    func isNetworkAvaiblable() -> Bool {
        if let reachability = Reachability() {
            return reachability.isReachable
        }
        return true
    }
}


