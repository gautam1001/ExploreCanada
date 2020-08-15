//
//  ApiResponse.swift
//
//  Created by Prashant Gautam on 12/03/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

/// Response used to store URL response.
class Response {

    // MARK: Declaration for string constants to be used to decode and also serialize.

    private struct SerializationKeys {
        static let statusCode = "statusCode"
        static let message = "message"
        static let success = "success"
    }

    // The URL request sent to the server.
    var request: URLRequest?

    // The server's response to the URL request.
    var response: HTTPURLResponse?

    // The data returned by the server.
    var data: Data?

    // The error received during the request.
    var error: Error?

    // The dictionary received after parsing the received data.
    var resultJSON: Dictionary<String, Any>?
   
    //private var jsonSuccessCheck:Bool = true
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
                if !success() {
                    self.error = errorGenerator(responseCode(), message())
                }
            } catch let error as NSError {
                // Catxch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                self.error = error
            }
        }
    }

    /*init(_ request: URLRequest?, _ response: HTTPURLResponse?, _ connectionError: Error, data: Data? = nil) {
        self.request = request
        self.response = response
        error = connectionError

        if let resultData = data {
            self.data = resultData
            do {
                // Try parsing some valid JSON
                resultJSON = try JSONSerialization.jsonObject(with: self.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary
                error = errorGenerator(responseCode(), message())
            } catch {
                self.error = connectionError
            }
        }
    }*/

    // MARK: - Getters Methods

    /**
     The response status after parsing the received data.

     - returns: true if success code return
     */
    func success() -> Bool {
        if  let resultJSON = resultJSON, let status = resultJSON[SerializationKeys.success] {
            return (status as AnyObject).boolValue
        }

        return true
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
    func responseCode() -> Int {
        if let resultJSON = resultJSON, let code = resultJSON[SerializationKeys.statusCode] as? Int {
            return code
        }else if let response = self.response {
            return response.statusCode
        }
        return -1 // Unknown response code.
    }

    /**
     The message received after parsing the received data.

     - returns: response message from api response data.
     */
    func message() -> String {
        if let resultJSON = resultJSON, let message = resultJSON[SerializationKeys.message] as? String {
            return message
        }
        return (success()) ? NSLocalizedString("Action performed successfully.", comment: "Action performed successfully.") : NSLocalizedString("An error occurred while performing this request. Please try again later.", comment: "An error occurred while performing this request. Please try again later.")
    }

    /**
     The responseError received after parsing the received data.

     - returns: error if api failed.
     */

    fileprivate func errorGenerator(_ code: Int, _ message: String) -> Error {
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", comment: "Error"), NSLocalizedDescriptionKey: message]
        return NSError(domain: "com.httprequest", code: code, userInfo: errorDictionary)
    }
}


//    if let httpResponse = response {
//                   if httpResponse.statusCode > 299 {
//                       if httpResponse.statusCode == HTTPStatusCode.unauthorized.rawValue {
//                           responseError = NSError(domain: "ACCESSDENIED", code: 401, userInfo: [NSLocalizedDescriptionKey: ""])
//
//                       } else if data != nil {
//                           responseError = NSError.errorForHTTPStatus(httpResponse.statusCode)
//                       }
//                   }
//               }
