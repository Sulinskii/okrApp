//
//  BookListCell.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct BookListCell: View {
    let book: Book
    var body: some View {
        NavigationLink(destination: BookDetails(book: book)) {
            VStack(alignment: .leading) {
                Text(book.name)
                Text(book.artistName)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
}
