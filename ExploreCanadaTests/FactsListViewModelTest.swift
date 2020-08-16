//
//  FactsListViewModelTest.swift
//  ExploreCanadaTests
//
//  Created by Prashant on 16/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import XCTest
@testable import ExploreCanada


final class MockFactListViewModel:FactListServiceProtocol {
    
    var _aboutViewModel: AboutViewModel?
    var updateHandler: ListUpdateHandler?
    
    func fetch(_ handler: @escaping ListUpdateHandler) {
        updateHandler =  handler
        if let aboutViewModel = _aboutViewModel{
            self.updateHandler?(.success((aboutViewModel.screenTitle ?? "")))
        }else{
            self.updateHandler?(.failure(NetworkError.other(string: "Unable to fetch facts")))
        }
    }
    
}

class FactsListViewModelTest: XCTestCase {
    var listViewModel : MockFactListViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.listViewModel = MockFactListViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.setUp()
        self.listViewModel = nil
        super.tearDown()
    }

    func testFetchFactsSuccess() {
        let expectation = XCTestExpectation(description: "Facts fetch")
        self.listViewModel._aboutViewModel = AboutViewModel(with: About(title: "About Canada", facts: []))
        self.listViewModel.fetch { result in
            switch result {
            case .success( _): expectation.fulfill()
            case .failure( let error): XCTAssert(false, error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFactsNoResult() {
        let expectation = XCTestExpectation(description: "Facts fetch")
        self.listViewModel._aboutViewModel = nil
        self.listViewModel.fetch { result in
            switch result {
            case .success( _): XCTAssert(false, "Facts should not be fetched")
            case .failure( _): expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

