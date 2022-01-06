//
//  Book.swift
//  AppOKR
//
//  Created by Artur Sulinski on 31/12/2021.
//

import Foundation

struct Book: Codable, Identifiable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String
    let kind: String
    let artistId: String
    let artistUrl: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
}
