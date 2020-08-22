//
//  MockRequestBuilder.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 22/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation
@testable import ExploreCanada
enum MockRequestBuilder {
    case getFacts
    case getFactsBadUrl
    case getFactsInvalidJson
    var baseUrl:String {
        return "https://dl.dropboxusercontent.com/"
    }
}

extension MockRequestBuilder {
    var method: HTTPRequestMethod {
        switch self {
        case .getFacts, .getFactsBadUrl, .getFactsInvalidJson :
            return .GET
        }
        //Note: Can extend the cases based on the request types (POST, PUT, DELETE etc)
    }
}

extension MockRequestBuilder {
    private func endPoint() -> String {
        switch self {
        case .getFacts, .getFactsInvalidJson:
            return "s/408h1ndn4cwy2f5/AboutCanada.json"
        case .getFactsBadUrl:
            return "s/408h1ndn4cwy2f5//About Canada.json"
        }
    }
    
    var path: String {
        return baseUrl + endPoint()
    }
}

extension MockRequestBuilder {
    
    public var url:URL? {
        guard let url = URL(string: path) else { return nil}
        return url
    }
}

extension MockRequestBuilder {
    var parameters: [String: Any] {
        switch self {
        case .getFacts, .getFactsBadUrl, .getFactsInvalidJson:
            return [:]
        }
    }
}



