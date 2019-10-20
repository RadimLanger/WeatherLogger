//
//  APIQuery.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

protocol APIQuery {
    var request: URLRequest? { get }
    var urlString: String { get }
    var httpMethod: HttpMethod { get }
    var headerDictionary: [String: String] { get }
    var bodyDictionary: [String: Any] { get }
}

extension APIQuery {

    var request: URLRequest? {

        guard let url = URL(string: urlString) else {
            debugPrint("⚠️ Error creating URL from string: \(urlString)")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        headerDictionary.forEach({ key, value in
            request.addValue(value, forHTTPHeaderField: key)
        })
        if bodyDictionary.isEmpty == false {
            request.httpBody = preparePostParameters(bodyDictionary)
        }
        return request
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
