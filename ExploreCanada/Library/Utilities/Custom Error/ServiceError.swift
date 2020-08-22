//
//  ServiceError.swift
//  ExploreCanada
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case notInitialized
    case jsonSerialize
    case badUrl
    case other(String)
}
extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notInitialized:
            return NSLocalizedString("Fact service not initialized", comment: "Fact service not initialized")
        case .badUrl:
            return NSLocalizedString("Bad url", comment: "Bad url")
        case .jsonSerialize:
            return NSLocalizedString("Json encoding error", comment: "")
        case .other(let message):
            return NSLocalizedString(message, comment: "")
            
        }
    }
}
