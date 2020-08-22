//
//  NetworkError.swift
//
//  Created by Prashant on 07/10/19.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case reachability
    case requestTimedOut
    case other(string: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .reachability:
            return NSLocalizedString("Unable to reach the internet.", comment: "No Internet")
        case .requestTimedOut:
            return NSLocalizedString("Request timed out", comment: "Request timed out")
        case .other(let message):
            return NSLocalizedString(message, comment: "Response error")
        }
    }
    
   
}
