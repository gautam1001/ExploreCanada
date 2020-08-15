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
    var request: URLRequest?

    // The server's response to the URL request.
    private var response: HTTPURLResponse?

    // The data returned by the server.
    var data: Data?

    // The error received during the request.
    var error: Error?

    // The dictionary received after parsing the received data.
    var resultJSON: Dictionary<String, Any>?
   
    // MARK: - Initialization Methods

    init(_ request: URLRequest, _ response: HTTPURLResponse?, _ responseData: Data?, error: Error?) {
        self.request = request
        self.response = response
        self.error = error
        self.data = responseData
        if error == nil, let data = self.data{
            do {
                // Try parsing some valid JSON
                resultJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary
            } catch let parsingError {
                // Catxch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                self.error = parsingError
            }
        }else{
            self.error = error
        }
    }
    
    /**
     The response string from the received data.

     - returns: Returns the response as a string
     */
    func outputText() -> String? {
        guard let data = data else {
            return nil
        }

        return String(data: data as Data, encoding: String.Encoding.utf8)
    }

    /**
     The responseCode received after parsing the received data.

     - returns: get response code from api response data.
     */
    var statusCode: Int {
        if let response = self.response {
            return response.statusCode
        }
        return -1 // Unknown response code.
    }

}
