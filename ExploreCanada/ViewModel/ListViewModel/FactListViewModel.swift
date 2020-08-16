//
//  FactListViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation


protocol FactListServiceProtocol:ListServiceProtocol {
    var _aboutViewModel : AboutViewModel? { get set }
}

extension FactListServiceProtocol {
    var count: Int {
        return _aboutViewModel?.factCounts ?? 0
    }
}

class FactListViewModel:FactListServiceProtocol {

    var _aboutViewModel : AboutViewModel?
    
    typealias FactListUpdateHandler = ListUpdateHandler
    
    var updateHandler: FactListUpdateHandler?
    
    var title:String?{
        return _aboutViewModel?.screenTitle
    }
    var count:Int{
        return _aboutViewModel?.factCounts ?? 0
    }
    
    func fetch(_ handler: @escaping FactListUpdateHandler){
        updateHandler =  handler
        let request = RequestBuilder.getFacts
        APIService.shared.performRequest(request) { [weak self] result in
                   switch result {
                   case .success(let data):
                           self?._aboutViewModel = AboutViewModel(with: data)
                           self?.updateHandler?(.success((self?._aboutViewModel?.screenTitle ?? "")))
                   case .failure(let error):
                       self?.updateHandler?(.failure(error))
                   }
        }
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
