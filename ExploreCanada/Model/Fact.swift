//
//  Fact.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

struct Fact: Codable {
    var title : String?
    var description : String?
    var imageHref : String?
    //Note: Coding keys are not required as properties are with the same name of keys in json.
}
