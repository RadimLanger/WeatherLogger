//
//  CurrentWeatherQuery.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

struct CurrentWeatherQuery: APIQuery {

    enum SearchParameter {
        case city(name: String, state: String)
        case geographicCoordinates(latitude: Double, longitude: Double)

        var urlRepresentation: String {
            switch self {
                case .city(let name, let state):
                    return "&q=\(name),\(state)"
                case .geographicCoordinates(let latitude, let longitude):
                    return "&lat=\(latitude)&lon=\(longitude)"
            }
        }
    }

    let headerDictionary = ["Content-Type": "application/json"]
    let bodyDictionary = [String: Any]()
    let urlString: String
    let httpMethod = HttpMethod.get

    init(searchParameter: SearchParameter) {
        urlString = APIConstants.baseUrlStringWithApiKey + "&units=metric" + searchParameter.urlRepresentation
    }
}
