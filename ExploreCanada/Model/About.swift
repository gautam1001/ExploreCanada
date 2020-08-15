//
//  About.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

struct About: Codable {
    var title : String?
    var facts : [Fact]?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case facts = "rows"
    }
}
