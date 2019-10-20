//
//  HttpClientImpl.swift
//

import Foundation

final class HttpClientImpl: HttpClient {

    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    private func toggleStatusBarActivityIndicator(_ toggle: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = toggle
        }
    }

    func plainExecute(
        apiQuery: APIQuery,
        completion: @escaping ((Result<HttpClientResponse, HttpClientError>) -> Void)
    ) {

        guard let request = apiQuery.request else { return }

        toggleStatusBarActivityIndicator(true)

        urlSession.dataTask(with: request) {(data, httpResponse, error) in

            self.toggleStatusBarActivityIndicator(false)

            guard let httpResponse = httpResponse as? HTTPURLResponse else {
                if let error = error {
                    completion(Result.failure(HttpClientError.dataTaskError(underlying: error)))
                } else {
                    completion(Result.failure(HttpClientError.unknownError))
                }
                return
            }
            let response = HttpClientResponse(statusCode: httpResponse.statusCode, data: data)
            completion(Result.success(response))
        }.resume()
    }

    func execute<StructResult: Decodable>(
        apiQuery: APIQuery,
        _ expectedType: StructResult.Type,
        completion: @escaping ((Result<StructResult, RequestExecutionError>) -> Void)
    ) {

        self.plainExecute(apiQuery: apiQuery) { result in
            switch result {
                case .success(let response):

                    if let decoded: StructResult = response.parse() {
                        completion(.success(decoded))
                        return
                    }

                    if 200..<299 ~= response.statusCode {
                        completion(.failure(.invalidResponse))
                    } else {
                        completion(.failure(.invalidStatusCode))
                    }
                case .failure:
                    completion(.failure(.networkError))
            }
        }
    }
}
