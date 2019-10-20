//
//  CurrentWeatherData.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

// MARK: - CurrentWeatherData
struct CurrentWeatherData: Codable, Equatable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

    // MARK: - Coord
    struct Coord: Codable, Equatable {
        let lon: Double
        let lat: Double
    }

    // MARK: - Clouds
    struct Clouds: Codable, Equatable {
        let all: Int
    }

    // MARK: - Main
    struct Main: Codable, Equatable {
        let temp: Double
        let pressure: Double
        let humidity: Double
        let tempMin: Double
        let tempMax: Double

        private enum CodingKeys: String, CodingKey {
               case temp = "temp"
               case pressure = "pressure"
               case humidity = "humidity"
               case tempMin = "temp_min"
               case tempMax = "temp_max"
        }
    }

    // MARK: - Weather
    struct Weather: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    // MARK: - Wind
    struct Wind: Codable, Equatable {
        let speed: Double
        let deg: Double
    }
}
