//
//  CurrentWeatherRemoteResource.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

final class CurrentWeatherRemoteResource: NSObject {

    private let httpClient: HttpClient 
    private var isLoading = false

    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    func fetchCurrentWeatherData(
        for query: CurrentWeatherQuery,
        completion: @escaping (Result<CurrentWeatherData, RequestExecutionError>) -> Void
    ) {
        guard isLoading == false else { return }
        isLoading = true
        
        httpClient.execute(apiQuery: query, CurrentWeatherData.self, completion: { [weak self] result in
            completion(result)
            self?.isLoading = false
        })
    }
}
