//
//  APIServiceTests.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 22/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import XCTest
@testable import ExploreCanada

class APIServiceTests: XCTestCase {
    // SUT's - Subjects under test
    var apiService: MockApiService!
    var requestBuilder:MockRequestBuilder!
    
    override func setUp() {
        super.setUp()
        apiService = MockApiService.shared
    }
    
    override func tearDown() {
        apiService = nil
        requestBuilder = nil
        super.tearDown()
    }
    
    /// Function to test for valid json received from server (mock)
    func testJsonResponse() {
        let expectation = XCTestExpectation(description: "Valid json response data expected")
        requestBuilder = MockRequestBuilder.getFacts
        apiService?.performRequest(requestBuilder, completion: { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(JsonParser.parse(About.self, data: data), "Expected codable object model") // Valid json format
            case .failure(_): XCTAssert(false, "Must be success")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Function to test for invalid json received from server (mock)
    func testInvalidResponseData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Invalid json response data expected")
        requestBuilder = MockRequestBuilder.getFactsInvalidJson
        apiService?.performRequest(requestBuilder, completion: { result in
            switch result {
            case .success(let data):
                XCTAssertNil(JsonParser.parse(About.self, data: data), "Expected nil object") // Invalid json format
                expectation.fulfill()
            case .failure(_): XCTAssert(false, "Must be success")
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Function to test for reachability error in case of no internet (mock)
    func testNoInternet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        apiService?.setReachability(false)
        requestBuilder = MockRequestBuilder.getFacts
        let expectation = XCTestExpectation(description: "Not reachable")
        apiService?.performRequest(requestBuilder, completion: {result in
            switch result {
            case .success(_): XCTAssert(false, "Must not be reachable to internet")
            case .failure(let error): XCTAssertNotNil(error)
            expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Function to test for getting error in case of request created with wrong  url format (mock)
    func testBadUrl() {
        let expectation = XCTestExpectation(description: "Bad url format")
        requestBuilder = MockRequestBuilder.getFactsBadUrl
        apiService?.performRequest(requestBuilder, completion: {result in
            switch result {
            case .success(_): XCTAssert(false, "Bad url format expected")
            case .failure(let error): XCTAssertEqual(error.localizedDescription, ServiceError.badUrl.localizedDescription)
            expectation.fulfill()
            }
            
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
