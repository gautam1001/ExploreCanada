//
//  MockHTTPRequestManager.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 22/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation
@testable import ExploreCanada
class MockReachability {
    // MARK: - *** Connection test methods ***
    var isReachable: Bool = true
}

class MockHTTPRequestManager {
    
    var reachability:MockReachability = MockReachability()
    
    var urlSession: MockURLSession = MockURLSession()
    
    // MARK: - Singleton Instance
    class var shared: MockHTTPRequestManager {
        struct Singleton {
            static let instance = MockHTTPRequestManager()
        }
        return Singleton.instance
    }
    
    private init() {}
    
    func isNetworkAvailable() -> Bool{
        return reachability.isReachable
    }
    
    var needInvalidResponse:Bool = false
    
    func performRequest(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) {
        guard isNetworkAvailable() else {
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
       let task =  urlSession.dataTask(with: request, completionHandler: { data, response, error in
            var apiResponse: Response
            apiResponse = Response(request, response as? HTTPURLResponse, data, error: error)
            //DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(apiResponse)
            //})
        })
        task.needInvalidResponse = self.needInvalidResponse
        task.resume()
    }
    
}


