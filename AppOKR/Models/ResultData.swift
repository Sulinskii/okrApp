//
//  ResultData.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

struct ResultData: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright: String
    let country: String
    let icon: String
    let updated: Date
    let books: [Book]
    let url: String
}
