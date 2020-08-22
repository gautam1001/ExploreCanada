//
//  Response.swift
//
//  Created by Prashant Gautam on 12/03/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

/// Response used to store URL response.
class Response {
    // The URL request sent to the server.
    var _request: URLRequest?
    
    // The server's response to the URL request.
    private var _httpResponse: HTTPURLResponse?
    
    // The data returned by the server.
    private var _data: Data?
    
    // The error received during the request.
    private var _error: Error?
    
    //MARK:Getters
    var error:Error?{
        return _error
    }
    var request:URLRequest?{
        return _request
    }
    var data: Data?{
        return _data
    }
    // MARK: - Initialization Methods
    
    init(_ request: URLRequest, _ response: HTTPURLResponse?, _ responseData: Data?, error: Error?) {
        _request = request
        _httpResponse = response
        _data = responseData
        if let error = error {
           _error = error
        }else if self.statusCode < HTTPStatusCode.ok.rawValue || self.statusCode >= HTTPStatusCode.multipleChoices.rawValue {
            _error = NetworkError.other(string: HTTPStatusCode(statusCode: self.statusCode).statusDescription)
        }
    }
    
    /**
     The responseCode received after parsing the received data.
     
     - returns: get response code from api response data.
     */
    var statusCode: Int {
        if let response = _httpResponse {
            return response.statusCode
        }
        return HTTPStatusCode.unknownStatus.rawValue // Unknown response code.
    }
    
}
