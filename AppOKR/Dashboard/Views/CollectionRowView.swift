//
//  CollectionRowView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct RowView: View {
    let books: [BookObject]
    let width: CGFloat
    let height: CGFloat
    let horizontalSpacing: CGFloat
    var body: some View {
        HStack(spacing: horizontalSpacing) {
            ForEach(books) { book in
                CollectionViewCell(book: book)
                    .frame(width: width, height: height)
                    .background(Color.yellow)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
