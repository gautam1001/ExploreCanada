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
    // SUT's - Subjects under test
    var service:FactService!
    
    override func setUp() {
        super.setUp()
        self.service = FactService(request: RequestBuilder.getFacts)
    }
    
    override func tearDown() {
        self.service = nil
        super.tearDown()
    }
    /// Function to test for getting error in case of  no request created with RequestBuilder (mock)
    func testNoRequest() {
        service.requestBuilder = nil
        service.fetch { [weak self]result in
            switch result {
            case .success( _):XCTAssertNil(self?.service.requestBuilder, "Expected nil request")
            case .failure( _): break
            }
        }
    }
    
    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
