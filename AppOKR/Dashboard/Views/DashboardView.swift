//
//  DashboardView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel = BooksViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                List(viewModel.books) { book in
                    BookListCell(book: book)
                }.tabItem {
                    Text("List view")
                }
                CollectionView(books: viewModel.podcasts)
                    .tabItem {
                        Text("Collection view")
                    }
            }.navigationBarTitle(Text("Books"))
        }
        .alert(isPresented: $viewModel.presentAlert) {
                Alert(
                    title: Text("Unable to fetch books"),
                    message: Text("Please try again"),
                    dismissButton: .default(Text("Okay"), action: {
                        viewModel.presentAlert = false
                        viewModel.fetchBooks()
                    }))
            }
    }
}
