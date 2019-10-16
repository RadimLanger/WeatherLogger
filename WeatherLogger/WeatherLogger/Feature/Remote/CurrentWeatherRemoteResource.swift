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

    func fetchCurrentWeatherData(completion: @escaping (Result<CurrentWeatherData, RequestExecutionError>) -> Void) {
        // todo: rename configuration url
        guard let url = URL(string: Configuration.urlString), isLoading == false else { return }

        var request = URLRequest(url: url, httpMethod: .get)
        request.addJsonContentType()
        isLoading = true

        httpClient.execute(request: request, CurrentWeatherData.self, completion: { [weak self] result in
            completion(result)
            self?.isLoading = false
        })
    }
}
