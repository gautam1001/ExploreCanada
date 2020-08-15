//
//  FactViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class FactViewModel {

    private var _fact:Fact!
    private init() {}
    
    init(with fact:Fact) {
        self._fact = fact
    }
    
    var title: String? {
        get {return _fact.title ?? "Title not available" }
       set{
          _fact?.title = newValue
       }
    }

    var description: String? {
       get {return _fact?.description ?? "Description not available" }
       set{
          _fact?.description = newValue
       }
    }

    var imageHref: String? {
       get {return _fact?.imageHref}
       set{
          _fact?.imageHref = newValue
       }
    }
}
