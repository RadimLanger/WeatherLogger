//
//  Configuration.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

enum Configuration {
    private static let apiKey = "7cb2b8bb7633d29f6737ea217c07a757"
    static let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=Riga,LV&APPID=\(apiKey)" // todo: make more configurable
}
