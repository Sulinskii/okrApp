//
//  BookListCell.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI
import Combine

struct BookListCell: View {
    let book: Book
    let bookDetails: BookDetails
    var cancellables = Set<AnyCancellable>()
    
    init(book: Book) {
        self.book = book
        self.bookDetails = BookDetails(book: book)
        handleAction()
    }
    
    var body: some View {
        NavigationLink(destination: self.bookDetails) {
            VStack(alignment: .leading) {
                Text(book.name)
                Text(book.artistName)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private mutating func handleAction() {
        bookDetails.action.sink(receiveValue: { value in
            print("RECEIVED VALUE: \(value)")
        }).store(in: &cancellables)
    }
}
