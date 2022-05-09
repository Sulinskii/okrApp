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
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor( keyPath: \BookObject.id, ascending: true)],
        animation: .easeInOut
    ) private var books: FetchedResults<BookObject>
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    List(books) { book in
                        BookListCell(book: book)
                    }
                
                    
                    Button("Fetch more books") {
                        numberOfBooksToFetch += 10
                        viewModel.fetchBooks(quantity: numberOfBooksToFetch)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .tabItem { Text("List view") }
    
                VStack {
                    Button("Sign out") {
                        authViewModel.signOut()
                    }
                    
                    
                    
                }
                .tabItem { Text("Sign out view") }
            }.navigationBarTitle(Text("Books"))
        }
        .onAppear() {
            viewModel.fetchBooks(quantity: numberOfBooksToFetch)
        }
        .alert(isPresented: $viewModel.presentAlert) {
            Alert(
                title: Text("Unable to fetch books"),
                message: Text("Please try again"),
                dismissButton: .default(Text("Okay"), action: {
                    viewModel.presentAlert = false
                    viewModel.fetchBooks(quantity: 10)
                }))
        }
    }
    
    
}
