//
//  Dictionary+Query.swift
//
//  Created by Prashant Gautam on 22/03/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

// MARK: Dictionary Extension

extension Dictionary {
    func queryItems() -> [URLQueryItem]? {
        if keys.isEmpty == false {
            var items = [URLQueryItem]()
            for key in keys {
                if key is String && self[key] is String {
                    items.append(URLQueryItem(name: key as! String, value: self[key] as? String))
                } else {
                    assertionFailure("Key and values should be String type")
                }
            }
            return items
        }
        return nil
    }
}

