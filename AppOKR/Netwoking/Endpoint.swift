//
//  Endpoint.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

struct Endpoint {   
    private(set) var method: HttpMethod = .get
    private(set) var params: [String: Any]?
    private(set) var headers: [String: String] = [:]
    private(set) var encoding: Encoding
    private(set) var path: String
}

enum Encoding {
    case jsonEncoding, queryParameters
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
}
