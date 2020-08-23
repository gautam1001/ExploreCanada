//
//  FactListViewModel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class FactListViewModel:FactListServiceProtocol {
    var factService: FactService?
    var _aboutViewModel : AboutViewModel?
    //----
    typealias FactListUpdateHandler = ListUpdateHandler
    var updateHandler: FactListUpdateHandler?
    
    required init(service:FactService) {
        factService = service
    }
    
    func fetchList(_ handler: @escaping FactListUpdateHandler){
        updateHandler =  handler
        guard let _ = self.factService else {
            updateHandler?(.failure(NetworkError.other(string: "No request initialized")))
            return
        }
        factService?.fetch { [weak self] result in
            switch result {
            case .success(let data):
                self?._aboutViewModel = AboutViewModel(with: data)
                self?.updateHandler?(.success((self?._aboutViewModel?.screenTitle ?? "")))
            case .failure(let error):
                self?.updateHandler?(.failure(error))
            }
        }
    }
}
