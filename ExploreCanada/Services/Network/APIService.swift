//
//  APIService.swift
//
//  Created by Prashant Gautam on 11/03/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

public final class APIService {
    private let httpClient: HTTPRequestManager
    // MARK: - Singleton Instance
    class var shared: APIService {
        struct Singleton {
            static let instance = APIService()
        }
        return Singleton.instance
    }
    
    private init() {
        httpClient = HTTPRequestManager.shared
    }
}

extension APIService {
    func isNetworkRechable() -> Bool {
        guard httpClient.isNetworkAvaiblable() else {
            return false
        }
        return true
    }

    func performRequest(_ request: RequestBuilder, completion: @escaping (_ result: Result<Data,Error>) -> Void) {
        guard let url = request.url else {return completion(.failure(ServiceError.badUrl))}
        do {
            let httpRequest = try URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as Dictionary?)
            httpClient.performRequest(httpRequest) { response in
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

    
    func cancel(_ request: RequestBuilder) {
        guard let url = URL(string: request.path) else { return }
        httpClient.cancelRequestForURL(url)
    }
    
    func cancelAllRequests(){
        httpClient.cancelAllRequests()
    }
}
