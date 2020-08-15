//
//  FactListViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation


class FactListViewModel {
    
    enum FactListResult<String,Error> {
        case success(String)
        case failure(Error)
    }
    
    private var _aboutViewModel : AboutViewModel?
    
    typealias FactListUpdateHandler = ((FactListResult<String,Error>) -> Void)
    private var updateHandler: FactListUpdateHandler?
    
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
            case .success(let jsonDict):
                if let jsonDict = jsonDict {
                    self?._aboutViewModel = AboutViewModel(with: jsonDict)
                    self?.updateHandler?(.success(self?._aboutViewModel?.screenTitle ?? ""))
                }
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
