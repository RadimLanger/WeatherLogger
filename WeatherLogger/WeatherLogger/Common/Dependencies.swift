//
//  Dependencies.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

struct Dependencies {
    let httpClient: HttpClient = HttpClientImpl(urlSession: URLSession.shared) 
}
