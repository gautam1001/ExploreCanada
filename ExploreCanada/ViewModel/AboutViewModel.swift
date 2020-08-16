//
//  AboutViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class AboutViewModel {
    
    private var _about:About?
    private var _factViewModels:[FactViewModel]?
    var factCounts:Int{
        return _factViewModels?.count ?? 0
    }
    
    private init() {}
    
    init(with about:About) {
        self._about = about
        self.populateFacts()
    }
    
    init(with data:Data) {
        guard let about =  JsonParser.parse(About.self, data: data) else {return}
        self._about = about
        self.populateFacts()
    }
    
    var screenTitle: String? {
        get {return _about?.title }
        set{
            _about?.title = newValue
        }
    }
    
    private func populateFacts(){
        if let facts = _about?.facts {
            _factViewModels = [FactViewModel]()
            for fact in facts {
                _factViewModels?.append(FactViewModel(with: fact))
            }
            // Remove empty facts
            _factViewModels = _factViewModels?.compactMap {
                if  (($0.title != nil) && ($0.description != nil) &&  ($0.imageHref != nil)){
                    return $0
                }
                return nil
            }
        }
        
    }
    
    //MARK: Getter setter for fact items in the list
    subscript(_ index: Int) -> FactViewModel? {
        get { return _factViewModels?[index] }
        set {
            if let value = newValue {
                _factViewModels?[index] = value
            }
        }
    }
    
}
