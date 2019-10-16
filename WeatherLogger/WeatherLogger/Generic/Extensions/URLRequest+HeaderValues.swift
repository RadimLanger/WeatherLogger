//
//  URLRequest+HeaderValues.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

extension URLRequest {

    init(url: URL, httpMethod: HttpMethod) {
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue
    }

    mutating func addJsonContentType() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    mutating func setBody(_ dictionary: [String: Any]) {
        self.httpBody = preparePostParameters(dictionary)
    }

    private func preparePostParameters(_ parameters: [String: Any]) -> Data {
        guard
            let encodedParameters = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        else {
            return Data()
        }

        return encodedParameters
    }
}
