//
//  MockURLSession.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 23/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

//---------------------------------------------------------//
class MockURLSession: URLSession {
    var completionHandler: ((Data, URLResponse, Error) -> Void)?
    override init() { }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> MockDataTask {
        self.completionHandler = completionHandler
        return MockDataTask(with: request, completionHandler: completionHandler)
    }
    
}

class MockDataTask: URLSessionDataTask {
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var needInvalidResponse:Bool = false
    private var data:Data? {
        return needInvalidResponse ? MockJson.inValidJsonData() : MockJson.validJsonData()
    }
    
    private var httpResponse:HTTPURLResponse?

    init(with request: URLRequest, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.completionHandler = completionHandler
        httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "", headerFields: [:])
    }
    
    override func resume() {
        completionHandler?(data, httpResponse,nil)
    }
}
