//
//  Link.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import Foundation

struct Link: Codable {
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case link = "self"
    }
}
