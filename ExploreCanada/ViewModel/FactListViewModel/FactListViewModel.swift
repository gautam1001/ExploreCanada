//
//  FactListViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class FactListViewModel {
    func fetchFacts(){
        let request = RequestBuilder.getFacts
        APIService.shared.performRequest(request) { (result, error) in
            if error == nil, let dataDict = result {
                let about =  JsonParser.parse(About.self, dict: dataDict)
                print(about)
            }
        }
    }
    
}

class AboutViewModel {

    private var _about:About!
    private init() {}
    init(with about:About) {
        self._about = about
    }
    
    var screenTitle: String? {
        get {return _about.title }
       set{
        _about.title = newValue
       }
    }

    var facts: [Fact]? {
       get {return _about?.facts}
       set{
          _about?.facts = newValue
       }
    }

    
}

class FactViewModel {

    private var _fact:Fact!
    private init() {}
    init(with fact:Fact) {
        self._fact = fact
    }
    
    var title: String? {
        get {return _fact.title }
       set{
          _fact?.title = newValue
       }
    }

    var description: String? {
       get {return _fact?.description}
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
