//
//  NetworkProvider.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

final class RequestProvider {
    
    private let baseURL = "https://www.boredapi.com"
    private let timeoutInterval: TimeInterval = 30.0
    
    func request(_ endpoint: Endpoint) -> URLRequest {
        let url = URL(string: baseURL + endpoint.path)!

        var request = URLRequest(url: url,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: timeoutInterval)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        return request
    }
}
