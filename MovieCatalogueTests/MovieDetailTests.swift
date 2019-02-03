//
//  MovieDetailTests.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/3/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
@testable import MovieCatalogue
class MovieDetailTests: XCTestCase {
    var movieDetailViewController: MovieDetailViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.viewModel = MovieDetailViewModel(networkProvider: NetworkProvider<NetworkRouter>(endpointClosure: networkEndPointClousure, stubClosure: NetworkProvider.delayedStub(1)))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieDetailWithStubResponse() {
        let promise = expectation(description: "Status code: 200")
        var count = 0
        var error: String?
        movieDetailViewController.viewModel.fetchMovieDetails(id: 517292) {[weak self] (errorMessage) in
            if errorMessage != nil {
                error = errorMessage
            } else {
                count = self?.movieDetailViewController.viewModel.movieDetail.count ?? -1
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(count, 8, "There are more or less than movie details record(s) for \(self.movieDetailViewController.viewModel.movieDetail.count) \(String(describing: error))")
    }
}
