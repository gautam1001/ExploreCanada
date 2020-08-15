//
//  FactListViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class FactListViewModel {
    private var _aboutViewModel : AboutViewModel?
    
    typealias FactListUpdateHandler = ()->Void
    private var updateHandler: FactListUpdateHandler?
    
    var count:Int{
        return _aboutViewModel?.factCounts ?? 0
    }
    
    func fetchFacts(){
        let request = RequestBuilder.getFacts
        APIService.shared.performRequest(request) { [weak self] (result, error) in
            if error == nil, let dataDict = result {
                self?._aboutViewModel = AboutViewModel(with: dataDict)
                self?.updateHandler?()
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
    
    func listUpdated(_ handler: @escaping FactListUpdateHandler){
        updateHandler = handler
    }
}
