//
//  DashboardView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = BooksViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            TabView {
                List(viewModel.books) { book in
                    BookListCell(book: book)
                }
                .tabItem {
                    Text("List view")
                }
                CollectionView(books: viewModel.podcasts)
                    .tabItem {
                        Text("Collection view")
                    }
                VStack {
                    Button("Sign out") {
                        authViewModel.signOut()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .tabItem {
                    Text("Sign out view")
                }
            }.navigationBarTitle(Text("Books"))
        }
        .onAppear() {
            viewModel.fetchBooks()
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
