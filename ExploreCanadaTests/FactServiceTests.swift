//
//  FactServiceTests.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import XCTest

@testable import ExploreCanada

class FactServiceTests: XCTestCase {
     // SUT - Subject under test
    var service:FactService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.service = FactService(request: RequestBuilder.getFacts)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.service = nil
        super.tearDown()
    }

    func testNoRequest() {
        service.requestBuilder = nil
        service.fetch { [weak self]result in
            switch result {
            case .success( _):XCTAssertNil(self?.service.requestBuilder, "Expected nil request")
            case .failure( let error): print(error.localizedDescription)
            }
        }
    }

    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
