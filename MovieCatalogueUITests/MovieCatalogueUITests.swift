//
//  MovieCatalogueUITests.swift
//  MovieCatalogueUITests
//
//  Created by Aadesh Maheshwari on 2/1/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest

class MovieCatalogueUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMovieListLoaded() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.count > 0)
    }
    
    func testMovieFilterScreen() {
        let app = XCUIApplication()
        app.navigationBars["TMDB List"].buttons["Filter"].tap()
        let minYear = app.textFields["e.g 2008"]
        minYear.tap()
        minYear.typeText("2008")
        let maxYear = app.textFields["e.g 2012"]
        maxYear.tap()
        maxYear.typeText("2012")
        app.buttons["FilterResult"].tap()
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.count > 0)
    }
}
