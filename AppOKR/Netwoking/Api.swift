//
//  Api.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

enum EndpointType {
    case books, podcasts
}

final class Api {
    public static let shared = Api()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let requestProvider: RequestProvider
    
    init(requestProvider: RequestProvider = RequestProvider()) {
        self.requestProvider = requestProvider
    }
    
    func fetchData(with type: EndpointType, quantity: Int) async throws -> ResultData {
        let endpoint = self.endpoint(with: type, quantity: quantity)
        let request = requestProvider.request(for: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        let validatedData = try validate(data, response)
        return try decoder.decode(ResultData.self, from: validatedData)
    }
    
//    func fetchBooks(_ quantity: Int) -> AnyPublisher<ResultData, Error> {
//        let endpoint = booksEndpoint(quantity)
//        let request = requestProvider.request(for: endpoint)
//
//        return dataPublisher(type: ResultData.self, request: request)
//    }
//
//    func fetchPodcasts() -> AnyPublisher<ResultData, Error> {
//        let endpoint = podcastsEndpoint()
//        let request = requestProvider.request(for: endpoint)
//
//        return dataPublisher(type: ResultData.self, request: request)
//    }
//
//    func dataPublisher<T: Decodable>(type: T.Type, request: URLRequest) -> AnyPublisher<T, Error> {
//        session.dataTaskPublisher(for: request)
//                .tryMap{ try Self.validate($0.data, $0.response)}
//                .decode(type: type, decoder: decoder)
//                .retry(numberOfRetries)
//                .eraseToAnyPublisher()
//    }
}

private extension Api {
    func endpoint(with type: EndpointType, quantity: Int) -> Endpoint {
        switch type {
        case .books:
            return booksEndpoint(quantity)
        case .podcasts:
            return podcastsEndpoint(quantity)
        }
    }
    
    func booksEndpoint(_ quantity: Int) -> Endpoint {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]

        return Endpoint(method: .get, params: nil, headers: headers, encoding: .jsonEncoding, path: "/api/v2/us/books/top-free/\(quantity)/books.json")
    }
    
    func podcastsEndpoint(_ quantity: Int) -> Endpoint {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]

        return Endpoint(method: .get, params: nil, headers: headers, encoding: .jsonEncoding, path: "/api/v2/us/podcasts/top/\(quantity)/podcast-episodes.json")
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
