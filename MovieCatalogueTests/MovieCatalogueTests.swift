//
//  MovieCatalogueTests.swift
//  MovieCatalogueTests
//
//  Created by Aadesh Maheshwari on 2/1/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
@testable import MovieCatalogue

class MovieCatalogueTests: XCTestCase {
    var moviesListViewController: MovieListViewController!
    override func setUp() {
        moviesListViewController = MovieListViewController()
        moviesListViewController.viewModel = MovieListViewModel(networkProvider: NetworkProvider<NetworkRouter>(endpointClosure: networkEndPointClousure, stubClosure: NetworkProvider.delayedStub(1)))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilterYearRecordsFunction() {
        let queryArray = moviesListViewController.viewModel.setfilterQuery(minyear: 2008, maxYear: 2012)
        XCTAssertEqual(queryArray.count, 5, "the function is not working as the count is not matching to required field \(queryArray)")
    }

    func testFetchMoviesWithStubResponse() {
        let promise = expectation(description: "Status code: 200")
        var count = 0
        var error: String?
        moviesListViewController.viewModel.fetchMovies(completionHandler: { (errorMessage) in
            if errorMessage != nil {
                error = errorMessage
            } else {
                count = self.moviesListViewController.viewModel.movies.count
            }
            promise.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(count > 0, "There are more or less than one record(s) for \(self.moviesListViewController.viewModel.movies.count) \(String(describing: error))")
    }
}
