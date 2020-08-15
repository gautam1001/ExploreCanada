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
     func performRequest(_ request: RequestBuilder, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        guard let url = request.url else {return} 
        let httpRequest = URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as NSDictionary?)
        guard let _ = httpRequest.url else {
            return completion(nil,NSError.errorForInvalidURL())
        }
        httpClient.performRequest(httpRequest) { response in
               if response.responseCode() == HTTPStatusCode.requestTimeout.rawValue {
                completion(nil, response.error)
               } else if let error = response.error{
                completion(nil, error)
            } else if response.success(), let responseData = response.resultJSON {
                completion(responseData, nil)
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
