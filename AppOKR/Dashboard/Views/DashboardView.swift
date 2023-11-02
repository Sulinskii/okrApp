//
//  DashboardView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI
import CoreData

struct DashboardView: View {
    
    @State var numberOfBooksToFetch = 10
    @StateObject var viewModel: BooksViewModel = BooksViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.appBackgroundColor) var backgroundColor
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookObject.id, ascending: true)],
        animation: .easeInOut
    ) private var books: FetchedResults<BookObject>
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            TabView {
                if verticalSizeClass == .regular {
                    VStack {
                        List(books) { book in
                            BookListCell(book: book)
                        }
                        
                        Text("Number of books in dashboard view: \(numberOfBooksToFetch)")
                            .padding()
                            .background(backgroundColor)
                            .cornerRadius(5)
                        
                        DashboardBottomView(numberOfBooksFetched: $numberOfBooksToFetch) {
                            numberOfBooksToFetch += 10
                            viewModel.fetchBooks(quantity: numberOfBooksToFetch)
                        }
                        .padding()
                        
                    }
                    .tabItem{ Text("List view") }
                } else {
                    HStack {
                        List(books) { book in
                            BookListCell(book: book)
                        }
                        
                        Text("Number of books in dashboard view: \(numberOfBooksToFetch)")
                            .padding()
                            .background(backgroundColor)
                            .cornerRadius(5)
                        
                        DashboardBottomView(numberOfBooksFetched: $numberOfBooksToFetch) {
                            numberOfBooksToFetch += 10
                            viewModel.fetchBooks(quantity: numberOfBooksToFetch)
                        }
                        .padding()
                        
                    }
                    .tabItem{ Text("List view") }
                }
                
                CollectionView(books: viewModel.podcasts)
                    .tabItem{ Text("Collection view") }
                
                VStack {
                    Button("Sign out") {
                        authViewModel.signOut()
                    }
                    .padding(.bottom, 20)
                    .accessibilityIdentifier("identifier")
                    Button("Delete user & sign out") {
                        authViewModel.deleteUser()
                    }
                }
                .tabItem{ Text("Sign out view") }
            }.navigationBarTitle(Text("Books"))
        }
        .onAppear() {
            if books.count > 0 {
                numberOfBooksToFetch = books.count
            }
            viewModel.fetchBooks(quantity: numberOfBooksToFetch)

        }
        .alert(isPresented: $viewModel.presentAlert) {
            Alert(
                title: Text("Unable to fetch books"),
                message: Text("Please try again"),
                primaryButton: .default(Text("Okay")),
                secondaryButton: .default(Text("Try again"), action: {
                    viewModel.presentAlert = false
                    viewModel.fetchBooks(quantity: 10)
                }))
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
                .environmentObject(AuthViewModel())
        }
    }
}
        
