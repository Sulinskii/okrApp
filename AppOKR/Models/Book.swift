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
    @CodableDefault.EmptyString var releaseDate: String
    let kind: String
    @CodableDefault.EmptyString var artistId: String
    @CodableDefault.EmptyString var artistUrl: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
}
