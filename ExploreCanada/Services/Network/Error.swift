//
//  RequestBuilder.swift
//
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badUrl(string: String)
    case rechability(string: String)
    case requestTimedOut(string: String)
    case other(string: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badUrl(let message):
            return NSLocalizedString(message, comment: "Bad url")
        case .rechability(let message):
            return NSLocalizedString(message, comment: "Unable to reach network")
        case .requestTimedOut(let message):
            return NSLocalizedString(message, comment: "Request timed out")
        case .other(let message):
            return NSLocalizedString(message, comment: "Response error")
        }
    }
}
