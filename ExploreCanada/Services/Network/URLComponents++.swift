//
//  URLComponents++.swift
//  NetworkLayer
//
//  Created by Prashant Gautam on 13/06/20.
//  Copyright © 2020 Prashant. All rights reserved.
//

import Foundation
extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: Any]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
    }
    
    mutating func setQueryItems(with parameters: NSDictionary) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key as! String, value:"\($0.value)") }
    }
}
