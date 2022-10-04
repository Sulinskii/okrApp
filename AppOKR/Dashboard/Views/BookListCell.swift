//
//  BookListCell.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct BookListCell: View {
    let book: BookObject
    let bookDetails: BookDetails
    
    init(book: BookObject) {
        self.book = book
        self.bookDetails = BookDetails(book: book)
//        handleAction()
    }
    
    var body: some View {
        NavigationLink(destination: self.bookDetails) {
            VStack(alignment: .leading) {
                Text(book.name ?? "")
                Text(book.artistName ?? "")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
    
//    private mutating func handleAction() {
//        bookDetails.action.sink(receiveValue: { value in
//            print("RECEIVED VALUE: \(value)")
//        }).store(in: &cancellables)
//    }
}
