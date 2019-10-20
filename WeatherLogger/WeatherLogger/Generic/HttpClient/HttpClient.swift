//
//  HttpClient.swift
//

import Foundation

protocol HttpClient {

    func plainExecute(
        apiQuery: APIQuery,
        completion: @escaping ((Result<HttpClientResponse, HttpClientError>) -> Void)
    )

    func execute<StructResult: Decodable>(
        apiQuery: APIQuery,
        _ expectedType: StructResult.Type,
        completion: @escaping ((Result<StructResult, RequestExecutionError>) -> Void)
    )
}
