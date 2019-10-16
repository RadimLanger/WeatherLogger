//
//  CurrentWeatherData.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

struct CurrentWeatherData: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City

    private enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }

    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int

        struct Coord: Codable {
            let lat: Double
            let lon: Double
        }
    }

    struct List: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let dtTxt: String
        let rain: Rain?

        private enum CodingKeys: String, CodingKey {
            case dt = "dt"
            case main = "main"
            case weather = "weather"
            case clouds = "clouds"
            case wind = "wind"
            case dtTxt = "dt_txt"
            case rain = "rain"
        }

        struct Clouds: Codable {
            let all: Int
        }

        struct Main: Codable {
            let temp: Double
            let tempMin: Double?
            let tempMax: Double?
            let pressure: Int
            let seaLevel: Int
            let grndLevel: Double
            let humidity: Int
            let tempKf: Double

            enum CodingKeys: String, CodingKey {
                case temp = "temp"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case pressure = "pressure"
                case seaLevel = "sea_level"
                case grndLevel = "grnd_level"
                case humidity = "humidity"
                case tempKf = "temp_kf"
            }
        }

        struct Rain: Codable {
            let the1h: Double?
            let the3h: Double?
        }

        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String?
            let icon: String
        }

        struct Wind: Codable {
            let speed: Double
            let deg: Double
        }
    }
}
