//
//  MockFactListViewModel.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation
@testable import ExploreCanada

final class MockFactListViewModel:FactListServiceProtocol {
   
    var _aboutViewModel: AboutViewModel?
    var updateHandler: ListUpdateHandler?
    var factService: FactService?
    
    init(service: FactService) {
        factService = service
    }
    
    func fetchList(_ handler: @escaping ListUpdateHandler) {
        updateHandler =  handler
        if let aboutViewModel = _aboutViewModel{
            self.updateHandler?(.success((aboutViewModel.screenTitle ?? "")))
        }else{
            self.updateHandler?(.failure(NetworkError.other(string: "Unable to fetch facts")))
        }
    }
}
