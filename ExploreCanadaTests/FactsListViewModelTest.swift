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
    // SUT - Subjects under test
    var listViewModel : FactListServiceProtocol!
    var factService:FactService!
    override func setUp() {
         super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.factService = FactService(request: RequestBuilder.getFacts)
        self.listViewModel = MockFactListViewModel(service: self.factService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.listViewModel = nil
        self.factService = nil
        super.tearDown()
    }
    
    func testFetchFactsSuccess() {
        let expectation = XCTestExpectation(description: "Facts fetch")
        self.listViewModel?._aboutViewModel = AboutViewModel(with: About(title: "About Canada", facts: []))
        self.listViewModel?.fetchList { result in
            switch result {
            case .success( _): expectation.fulfill()
            case .failure( let error): XCTAssert(false, error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFactsNoResult() {
        let expectation = XCTestExpectation(description: "Facts fetch")
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
        
        let expectation = XCTestExpectation(description: "No service facts")
        // giving no service to a view model
        self.listViewModel?.factService = nil
        
        listViewModel?.fetchList({ result in
            switch result {
            case .success( _): XCTAssert(false, "Facts should not be fetched")
            case .failure( _): expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

