//
//  ApiError.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

enum APIError: Error {
    case invalidBody
    case invalidEndpoint
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int)
}
