//
//  RequestBuilder.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

enum RequestBuilder {
    case getFacts
    
    var baseUrl:String {
        return "https://dl.dropboxusercontent.com/"
    }
}

extension RequestBuilder {
    var method: HTTPRequestMethod {
        switch self {
        case .getFacts:
            return .GET
        }
        //Note: Can extend the cases based on the request types (POST, PUT, DELETE etc)
    }
}

extension RequestBuilder {
    private func endPoint() -> String {
        switch self {
        case .getFacts:
            return "s/67zezivdylh8flh/Facts.json"
        }
    }
    
    var path: String {
        return baseUrl + endPoint()
    }
}

extension RequestBuilder {
    
   public var url:URL? {
        guard let url = URL(string: path) else { return nil}
        return url
    }
}

extension RequestBuilder {
    var parameters: [String: Any] {
        switch self {
            case .getFacts:
            return [:]
        }
    }
}
