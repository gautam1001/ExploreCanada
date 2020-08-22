//
//  FactsService.swift
//  ExploreCanada
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation


final class FactService: FactServiceProtocol {
    
    var responseHandler: CompletionHandler?
    
    var requestBuilder: RequestBuilder?
    
    init(request:RequestBuilder) {
        self.requestBuilder = request
     }
    
    func fetch(_ handler:@escaping CompletionHandler){
        responseHandler = handler
        guard let _request = self.requestBuilder else {
            responseHandler?(.failure(ServiceError.other("Request not created for the fetching facts.")))
            return
        }
        APIService.shared.performRequest(_request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.responseHandler?(.success(data))
            case .failure(let error):
                self?.responseHandler?(.failure(error))
            }
        }
    }
    
    func cancel(){
        guard let _requestBuilder = self.requestBuilder else {return}
        APIService.shared.cancel(_requestBuilder)
    }
}
