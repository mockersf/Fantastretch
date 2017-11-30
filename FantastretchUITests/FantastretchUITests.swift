//
//  FantastretchUITests.swift
//  FantastretchUITests
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import XCTest

class FantastretchUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func addNewAndRate() {

        let app = XCUIApplication()
        app.tabBars.buttons["Stretch List"].tap()
        app.navigationBars["Stretches"].buttons["Add"].tap()
        app.navigationBars["New Stretches"].buttons["New"].tap()

        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery /* @START_MENU_TOKEN@ */ .textFields["Stretch Name"] /* [[".cells.textFields[\"Stretch Name\"]",".textFields[\"Stretch Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        tablesQuery2.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("My New Stretch")
        tablesQuery2.cells.containing(.staticText, identifier: "Muscle").staticTexts["Choose one"].tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .staticTexts["Calves"] /* [[".cells.staticTexts[\"Calves\"]",".staticTexts[\"Calves\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .staticTexts["Choose one"] /* [[".cells.staticTexts[\"Choose one\"]",".staticTexts[\"Choose one\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .staticTexts["Once"] /* [[".cells.staticTexts[\"Center and Sides\"]",".staticTexts[\"Center and Sides\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()

        let textView = tablesQuery2.children(matching: .cell).element(boundBy: 4).children(matching: .textView).element
        textView.tap()
        textView.typeText("Description for stretch")
        app.navigationBars["New Stretch"].buttons["Save"].tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .staticTexts["My New Stretch"] /* [[".cells.staticTexts[\"My New Stretch\"]",".staticTexts[\"My New Stretch\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .buttons["Set 4 star rating"] /* [[".cells.buttons[\"Set 4 star rating\"]",".buttons[\"Set 4 star rating\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        app.navigationBars["My New Stretch"].buttons["Stretches"].tap()

        let stretchesNavigationBar = app.navigationBars["Stretches"]
        stretchesNavigationBar.buttons["Edit"].tap()

        //        let tablesQuery = app.tables
        tablesQuery /* @START_MENU_TOKEN@ */ .buttons["Delete My New Stretch, Calves, Once"] /* [[".cells.buttons[\"Delete My New Stretch, Calves, Center and Sides\"]",".buttons[\"Delete My New Stretch, Calves, Center and Sides\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        tablesQuery.buttons["Delete"].tap()
        stretchesNavigationBar.buttons["Done"].tap()
    }
}
