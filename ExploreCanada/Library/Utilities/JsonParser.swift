//
//  JsonParser.swift
//
//  Created by Prashant on 16/06/20.
//  Copyright © 2020 Prashant. All rights reserved.
//

import Foundation

class JsonParser {
    class func parse<T: Codable>(_: T.Type, data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
