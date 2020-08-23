//
//  FactListServiceProtocol.swift
//  ExploreCanada
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

protocol FactServiceProtocol{
    typealias CompletionHandler = (ListResult<Data, Error>) -> Void
    var requestBuilder:RequestBuilder? { get set }
    var responseHandler: CompletionHandler? { get set }
    func cancel()
    
}


protocol FactListServiceProtocol:ListServiceProtocol {
    var _aboutViewModel : AboutViewModel? { get set }
    var factService:FactService? { get set }
    init(service:FactService)
    subscript(_ index: Int) -> FactViewModel? { get set }
}

extension FactListServiceProtocol {

     var title:String?{
         return _aboutViewModel?.screenTitle
     }
    
    var count: Int {
        return _aboutViewModel?.factCounts ?? 0
    }
    //MARK: Getter setter for factviewmodel items in the list
    subscript(_ index: Int) -> FactViewModel? {
        get { return _aboutViewModel?[index] }
        set {
            if let value = newValue {
                _aboutViewModel?[index] = value
            }
        }
    }
}
