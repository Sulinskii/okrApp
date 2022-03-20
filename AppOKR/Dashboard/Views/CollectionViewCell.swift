//
//  CollectionViewCell.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct CollectionViewCell: View {
    let book: Book
    var body: some View {
        NavigationLink(destination: BookDetails(book: book)) {
            Text(book.name)
                .font(.subheadline)
                .lineLimit(nil)
        }
    }
}
