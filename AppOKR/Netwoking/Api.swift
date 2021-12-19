//
//  Api.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation
import Combine

final class Api {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let requestProvider: RequestProvider
    
    init(requestProvider: RequestProvider = RequestProvider()) {
        self.requestProvider = requestProvider
    }
    
    func fetchBooks() -> AnyPublisher<Feed, Error> {
        let endpoint = booksEndpoint()
        let request = requestProvider.request(endpoint)

        return session.dataTaskPublisher(for: request)
                .tryMap{ try self.validate($0.data, $0.response)}
                .decode(type: Feed.self, decoder: decoder)
                .eraseToAnyPublisher()
        }
    
}

private extension Api {
    func booksEndpoint() -> Endpoint {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]

        return Endpoint(method: .get, params: nil, headers: headers, encoding: .jsonEncoding, path: "bla")
    }
}

private extension Api {
    func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }
        return data
    }
}
