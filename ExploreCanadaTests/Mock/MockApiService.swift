//
//  MockApiService.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 22/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation
@testable import ExploreCanada

class MockApiService {
    
    private let httpClient: MockHTTPRequestManager
    
    // MARK: - Singleton Instance
    class var shared: MockApiService {
        struct Singleton {
            static let instance = MockApiService()
        }
        return Singleton.instance
    }
    
    private init() {
        httpClient = MockHTTPRequestManager.shared
    }
    
    func setReachability(_ value:Bool){
        httpClient.reachability.isReachable = value
    }
    
    func performRequest(_ request: MockRequestBuilder, completion: @escaping (_ result: Result<Data,Error>) -> Void) {
        guard let url = request.url else {
            completion(.failure(ServiceError.badUrl))
            return
        }
        do {
            let httpRequest = try URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as Dictionary?)
            httpClient.needInvalidResponse = request == .getFactsInvalidJson
            httpClient.performRequest(httpRequest) { (response) in
                if let error = response.error{
                    completion(.failure(NetworkError.other(string: error.localizedDescription)))
                } else if let responsedata = response.data {
                    completion(.success(responsedata))
                }
            }
            
        }catch let error {
            completion(.failure(error))
        }
    }
    
}






