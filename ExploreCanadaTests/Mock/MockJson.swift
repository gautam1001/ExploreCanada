//
//  MockJson.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 22/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class MockJson {
    
    static func validJsonData() -> Data?{
        let json = [
            "title": "About Canada",
            "rows": [
            [
            "title": "Beavers",
            "description": "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
            "imageHref": "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
            ],
            [
            "title": "Flag",
            "description": NSNull(),
            "imageHref": "http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"
            ]
            ]
            ] as [String : Any]
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return data
        }catch{
             return nil
        }
    }
    
    static func inValidJsonData() -> Data?{
        let json = "[\"title\":\"About Canada\",\"rows\":[\"[\"title\":\"Beavers\",\"description\":\"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony\",\"imageHref\":\"\"],[\"title\":\"Flag\",\"description\":null,\"imageHref\":\"\"]]"
        let data = Data(json.utf8)
        return data
    }
}
