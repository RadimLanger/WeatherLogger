//
//  WeatherLoggerUITests.swift
//  WeatherLoggerUITests
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import XCTest

class WeatherLoggerUITests: XCTestCase {

    let app = XCUIApplication()

    func test_addingAndDeletingWeatherRecord() {
        app.launchArguments = ["--ResetForUITesting"]
        app.launch()

        let saveButton = app.buttons[AccessibilityIdentifier.currentWeatherViewSaveButton.rawValue]

        waitForElementToAppear(saveButton)
        XCTAssertEqual(app.cells.count, 0, "There should be no cells in the beginning")
        saveButton.tap()

        handleAuthorizationAlertIfNeeded()

        let cell = app.cells[AccessibilityIdentifier.currentWeatherCell.rawValue]
        XCTAssertEqual(app.cells.count, 1, "There should be 1 cell after loading request")
        waitForElementToAppear(cell)
        cell.tap()

        let deleteButton = app.buttons[AccessibilityIdentifier.weatherDetaiViewDeleteButton.rawValue]
        waitForElementToAppear(deleteButton)
        deleteButton.tap()
        XCTAssertEqual(app.cells.count, 0, "There should be no cells after deleting the record")
    }

    @discardableResult
    func waitForElementToAppear(_ element: XCUIElement, canBeSkipped: Bool = false) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)

        let result = XCTWaiter().wait(for: [expectation], timeout: 5)

        if result != .completed && canBeSkipped == false {
            XCTFail("Couldnt find \(element)")
        }
        return result == .completed
    }

    private func handleAuthorizationAlertIfNeeded() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowButton = springboard.buttons["Allow"]

        if waitForElementToAppear(allowButton, canBeSkipped: true) {
            allowButton.tap()
        }
    }
}
