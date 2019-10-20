//
//  WeatherLoggerTests.swift
//  WeatherLoggerTests
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import XCTest
@testable import WeatherLogger

class CurrentWeatherTableDataSourceTests: XCTestCase {
    
    private var dataSource: CurrentWeatherTableDataSource?
    private let weatherDataStub = CurrentWeatherData(
        coord: .init(lon: 0, lat: 0),
        weather: [],
        base: "",
        main: .init(temp: 0, pressure: 0, humidity: 0, tempMin: 0, tempMax: 0),
        visibility: 0,
        wind: .init(speed: 0, deg: 0),
        clouds: .init(all: 0),
        dt: 0,
        timezone: 0,
        id: 0,
        name: "",
        cod: 0
    )

    override func setUp() {
         dataSource = CurrentWeatherTableDataSource()
    }

    func test_whenDataAreLoading_thenLoadingIndicatorShouldBeInDataSource() {
        dataSource?.isLoading = true
        XCTAssertTrue(dataSource!.sections[0].items.contains(.loadingIndicator))
    }

    func test_whenDataAreNotLoading_thenLoadingIndicatorShouldNotBeInDataSource() {
        dataSource?.isLoading = false
        XCTAssertFalse(dataSource!.sections[0].items.contains(.loadingIndicator))
    }

    func test_whenOnlyOneResultIsLoaded_thenNoSeparatorsShouldBeVisible() {
        dataSource?.weatherData = [weatherDataStub]
        XCTAssertEqual(dataSource!.sections[0].items, [.weather(weatherDataStub)])
    }

    func test_whenMoreWeatherDataIsLoaded_thenSeparatorsShouldBeBetweenItems() {
        dataSource?.weatherData = [weatherDataStub, weatherDataStub, weatherDataStub]
        let expectedSeparatorIndexes = [1, 3]
        expectedSeparatorIndexes.forEach({
            XCTAssertEqual(dataSource!.sections[0].items[$0], .separator)
        })
    }
}
