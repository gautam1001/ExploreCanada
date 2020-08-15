//
//  About.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

struct About: Codable {
    var title : String
    var facts : [Fact]
    //Note: Coding keys are not required as properties are with the same name of keys in json.
}
