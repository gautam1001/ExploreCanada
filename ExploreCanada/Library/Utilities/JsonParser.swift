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
    
    class func parse<T: Codable>(_: T.Type, dict: [String: Any]) -> T? {
        do {
            let resultsData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return try JSONDecoder().decode(T.self, from: resultsData)
        } catch {
            return nil
        }
    }

    class func parseList<T: Codable>(_: T.Type, dictArray: [[String: Any]]) -> [T]? {
        do {
            let resultsData = try JSONSerialization.data(withJSONObject: dictArray, options: .prettyPrinted)
            return try JSONDecoder().decode([T].self, from: resultsData)
        } catch {
            return nil
        }
    }

    class func parseJsonString<T: Codable>(_: T.Type, string: String) -> T? {
        do {
            let data = string.data(using: String.Encoding.utf8)
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let resultsData = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            return try JSONDecoder().decode(T.self, from: resultsData)
        } catch {
            return nil
        }
    }
    
}
