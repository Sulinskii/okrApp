//
//  BookDetails.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI


struct BookDetails: View {
    let book: Book
    var body: some View {
        NavigationView {
            Text(book.releaseDate)
        }
    }
}

