//
//  NetworkManagerTests.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/3/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
@testable import MovieCatalogue

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkProvider<NetworkRouter>!
    override func setUp() {
        networkManager = AppProvider.networkManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchMoviesHTTPStatusCode200() {
        let promise = expectation(description: "Get movies list for year 2019")
        networkManager.request(NetworkRouter.searchMovies(apiKey: API_KEY, page: 1, query: "2019")) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case let .failure(error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    // Asynchronous test: faster fail
    func testFetchMoviesCompletes() {
        let promise = expectation(description: "Completion handler invoked")
        var statusCode : Int?
        var responseError: String?
        networkManager.request(NetworkRouter.searchMovies(apiKey: API_KEY + "skdb", page: 1, query: "2019")) { result in
            switch result {
            case let .success(moyaResponse):
                statusCode = moyaResponse.statusCode
            case let .failure(error):
                responseError = error.errorDescription
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 401)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            networkManager.request(NetworkRouter.searchMovies(apiKey: API_KEY, page: 1, query: "1990")) { result in
            }
        }
    }
    
    func testGetConfigHTTPStatusCode200() {
        let promise = expectation(description: "Get config API result")
        networkManager.request(NetworkRouter.getConfig(apiKey: API_KEY)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case let .failure(error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testGetMovieDetailsHTTPStatusCode200() {
        let promise = expectation(description: "Get movies details")
        networkManager.request(NetworkRouter.getMovieDetails(apiKey: API_KEY, id: 517292)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case let .failure(error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

}
