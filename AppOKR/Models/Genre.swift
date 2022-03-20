//
//  Genre.swift
//  AppOKR
//
//  Created by Artur Sulinski on 31/12/2021.
//

import Foundation

struct Genre: Codable {
    let name: String
    @CodableDefault.EmptyString var genreId: String
    @CodableDefault.EmptyString var url: String
}
