//
//  ListServiceProtocol.swift
//  ExploreCanada
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation


enum ListResult<T,Error>{
    case success(T)
    case failure(Error)
}

protocol ListServiceProtocol {
    typealias ListUpdateHandler = ((ListResult<Any,Error>) -> Void)
    func fetchList(_ handler: @escaping ListUpdateHandler)
    var updateHandler: ListUpdateHandler? { get set }
    var count:Int{ get }
}
