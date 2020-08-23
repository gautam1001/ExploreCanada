//
//  FactsListViewModelTest.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import XCTest
@testable import ExploreCanada

class FactsListViewModelTest: XCTestCase {
    // SUT's - Subjects under test
    var listViewModel : FactListServiceProtocol!
    var factService:FactService!
    
    override func setUp() {
        super.setUp()
        self.factService = FactService(request: RequestBuilder.getFacts)
        self.listViewModel = MockFactListViewModel(service: self.factService)
    }
    
    override func tearDown() {
        self.listViewModel = nil
        self.factService = nil
        super.tearDown()
    }
    
    /// Function to test for getting success response (mock)
    func testFetchFactsSuccess() {
        let expectation = XCTestExpectation(description: "Facts fetch")
        self.listViewModel?._aboutViewModel = AboutViewModel(with: MockJson.validJsonData()!)
        self.listViewModel?.fetchList { result in
            switch result {
            case .success( _): expectation.fulfill()
            case .failure( let error): XCTAssert(false, error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Function to test for getting no result in response (mock)
    func testFetchFactsNoResult() {
        let expectation = XCTestExpectation(description: "No Facts")
        self.listViewModel?._aboutViewModel = nil
        self.listViewModel?.fetchList { result in
            switch result {
            case .success( _): XCTAssert(false, "Facts should not be fetched")
            case .failure( _): expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFactsNoService() {
        let expectation = XCTestExpectation(description: "No service assigned")
        // no service assigned to the view model
        self.listViewModel?.factService = nil
        listViewModel?.fetchList({ result in
            switch result {
            case .success( _): XCTAssert(false, "Facts should not be fetched")
            case .failure( _): expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFactItemAtIndexFail() {
           self.listViewModel?._aboutViewModel = AboutViewModel(with: MockJson.validJsonData()!)
           //Since there are only two items in the list of facts the indexed element will be nil.
           let factViewModel = self.listViewModel?[2]
           XCTAssertNil(factViewModel, "No FactViewModel should be returned")
       }
    
    func testFactItemAtIndexSuccess() {
        self.listViewModel?._aboutViewModel = AboutViewModel(with: MockJson.validJsonData()!)
        //Since there are only two items in the list of facts the indexed element will return a factviewmodel.
        let factViewModel = self.listViewModel?[1]
        XCTAssertNotNil(factViewModel, "FactViewModel should be returned")
    }
    
    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

