//
//  Api.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation
import Combine

final class Api {
    public static let shared = Api()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let requestProvider: RequestProvider
    private let scheduler = DispatchQueue.global()
    private let numberOfRetries = 3
    
    init(requestProvider: RequestProvider = RequestProvider()) {
        self.requestProvider = requestProvider
    }
    
    func fetchBooks(_ quantity: Int) -> AnyPublisher<ResultData, Error> {
        let endpoint = booksEndpoint(quantity)
        let request = requestProvider.request(for: endpoint)

        return dataPublisher(type: ResultData.self, request: request)
    }
    
    func fetchPodcasts() -> AnyPublisher<ResultData, Error> {
        let endpoint = podcastsEndpoint()
        let request = requestProvider.request(for: endpoint)
        
        return dataPublisher(type: ResultData.self, request: request)
    }
    
    func dataPublisher<T: Decodable>(type: T.Type, request: URLRequest) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: request)
                .handleEvents(receiveSubscription: { subscription in
                    print("SUBSCRIPTION STARTED: \(subscription)")
                }, receiveOutput: { data, response in
                    print("RECEIVED OUTPUT: \(data), \(response)")
                }, receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("FINISHED")
                    case .failure(let error):
                        print("ERROR: \(error)")
                    }
                }, receiveCancel: {
                    print("RECEIVED CANCEL")
                }, receiveRequest: { request in
                    print("RECEIVED REQUEST: \(request)")
                })
                .tryMap{ try Self.validate($0.data, $0.response)}
                .decode(type: type, decoder: decoder)
                .catch{ (error: Error) -> AnyPublisher<T, Error> in
                    return Fail(error: error)
                            .delay(for: 3, scheduler: self.scheduler)
                            .eraseToAnyPublisher()
                }
                .retry(numberOfRetries)
                .print()
                .share()
                .eraseToAnyPublisher()
    }
}

private extension Api {
    func booksEndpoint(_ quantity: Int) -> Endpoint {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]

        return Endpoint(method: .get, params: nil, headers: headers, encoding: .jsonEncoding, path: "/api/v2/us/books/top-free/\(quantity)/books.json")
    }
    
    func podcastsEndpoint() -> Endpoint {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]

        return Endpoint(method: .get, params: nil, headers: headers, encoding: .jsonEncoding, path: "/api/v2/us/podcasts/top/10/podcast-episodes.json")
    }
}

private extension Api {
    static func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            print("ERROR")
            throw APIError.statusCode(httpResponse.statusCode)
        }
        return data
    }
}
