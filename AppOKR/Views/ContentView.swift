//
//  ContentView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: BooksViewModel
    var body: some View {
        NavigationView {
            TabView {
                List(viewModel.books) { book in
                    BookListCell(book: book)
                }.tabItem {
                    Text("List view")
                }
                CollectionView(books: viewModel.books)
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
                        viewModel.fetchDogsFacts()
                    }))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: .init())
        }
    }
}
