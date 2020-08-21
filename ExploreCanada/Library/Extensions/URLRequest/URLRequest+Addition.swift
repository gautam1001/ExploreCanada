//
//  URLRequest+Additions.swift
//
//  Created by Prashant Gautam on 13/03/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

/**
 * HTTP Methods
 */
enum HTTPRequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension URLRequest {
    /**
     Default url request timeout

     - returns: Default request timeout
     */
    fileprivate static func requestTimeoutInterval() -> TimeInterval {
        return 30.0
    }

    /**
     Creates a NSMutableURLRequest object

     - parameter URL:            URL
     - parameter method:         HTTPMethod
     - parameter jsonDictionary: jsonDictionary for creating mutable url request.
     * @return NSMutableURLRequest object.

     - returns: NSMutableURLRequest object.
     */
    static func requestWithURL(_ url: URL, method: HTTPRequestMethod = .POST, jsonDictionary: NSDictionary?) -> URLRequest {
        var mutableURLRequest: URLRequest = URLRequest(url: url)
        // Set the timeout interval of the receiver.
        mutableURLRequest.timeoutInterval = URLRequest.requestTimeoutInterval()
        // Set the request's content type to application/json
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // Designate the request a POST request and specify its body data
        mutableURLRequest.httpMethod = method.rawValue
        if method == .GET, let obj = jsonDictionary {
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.setQueryItems(with: obj)
            mutableURLRequest.url = urlComponents?.url
        }else if method != .GET, let obj = jsonDictionary {
            do {
                let data: Data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                mutableURLRequest.httpBody = data // Okay, the `json` is here, let's get the value for 'success' out of it
            } catch let serializeError {
                print("Error could not parse JSON.\n \(serializeError)") // Log the error thrown by `JSONObjectWithData`
            }
        }
        return mutableURLRequest
    }
}
