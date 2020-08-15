//
//  APIService.swift
//
//  Created by Prashant Gautam on 11/03/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

public final class APIService {
    private let httpClient: HTTPRequestManager
    var isSSLPinningEnabled = false {
        willSet {
            self.httpClient.setSSLPinning(newValue)
        }
    }
    
    var certificateFileName = "" {
        willSet {
            self.httpClient.setCertficateName(newValue)
        }
    }
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
    // MARK: - Perform request
    func performRequest(_ request: RequestBuilder, completion: @escaping (_ result: Result<Dictionary<String, Any>?,NetworkError>) -> Void) {
     guard let url = request.url else {return}
     let httpRequest = URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as NSDictionary?)
     guard let _ = httpRequest.url else {
        return completion(.failure(.badUrl(string: "Bad url")))
     }
     httpClient.performRequest(httpRequest) { response in
            if response.responseCode() == HTTPStatusCode.requestTimeout.rawValue {
                completion(.failure(.requestTimedOut(string: "Request timed out")))
            } else if let error = response.error{
                completion(.failure(.other(string: error.localizedDescription)))
         } else if response.success(), let responseJson = response.resultJSON {
                completion(.success(responseJson))
         }
        }
    }
    
    func cancelRequestForService(_ request: RequestBuilder) {
        guard let url = URL(string: request.path) else { return }
        httpClient.cancelRequestForURL(url)
    }

    // MARK: - Download request

    func download(_ request: URLRequest, handler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        httpClient.download(request, completionHandler: handler)
    }
}
