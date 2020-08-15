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
            self.httpClient.isSSLPinningEnabled = newValue
        }
    }
    
    var certificateFileName = "" {
        willSet {
            self.httpClient.certificateFileName = newValue
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

    /**
     Method used to handle api response and based on the status it calls completion handler

     - parameter response:   api response
     - parameter completion: completion handler
     */
    /*func handleResponse(_ apiresponse: Response?, completion: (_ success: Bool, _ error: Error?) -> Void) {
        if let response = apiresponse {
            if response.responseCode() == HTTPStatusCode.requestTimeout.rawValue {
                completion(false, response.error)
            } else if response.success() {
                completion(true, nil)
            } else {
                completion(false, response.error)
            }
        }
    }*/

    // MARK: - Perform request

    func perform(_ request: RequestBuilder, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let url = request.url else {return}
        let httpRequest = URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as NSDictionary?)
        guard let _ = httpRequest.url else {
            return completion(false,NSError.errorForInvalidURL())
        }
        httpClient.performRequest(httpRequest) { response in
            if response.responseCode() == HTTPStatusCode.requestTimeout.rawValue {
                completion(false, response.error)
            } else if response.success() {
                completion(true, nil)
            } else {
                completion(false, response.error)
            }
        }
    }
    
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

    func performRequestList(_ request: RequestBuilder, completion: @escaping (_ result: [[String: Any]]?, _ error: Error?) -> Void) {
       guard let url = request.url else {return}
        let httpRequest = URLRequest.requestWithURL(url, method: request.method, jsonDictionary: request.parameters as NSDictionary?)
        guard let _ = httpRequest.url else {
            return completion(nil,NSError.errorForInvalidURL())
        }
        httpClient.performRequest(httpRequest) { response in
            if response.responseCode() == HTTPStatusCode.requestTimeout.rawValue {
                completion(nil, response.error)
            } else if response.success(), let responseData = response.resultJSON?["data"] as? [[String: Any]] {
                completion(responseData, nil)
            } else {
                completion(nil, response.error)
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
