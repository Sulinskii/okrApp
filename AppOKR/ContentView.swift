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
        var books: [Book] = []
        TabView {
            List(books) { book in
                BookCell(book: book)
                }
                .tabItem {
                    Text("First tab")
                }
            Text("Second Tab")
                .tabItem {
                    Text("Second tab")
                }
        }
        .navigationBarTitle(Text("Tutors"))
    }
}

struct BookCell: View {
    let book: Book
    var body: some View {
        Image(systemName: "photo")
        VStack(alignment: .leading) {
            Text("Simon Ng")
            Text("Founder of AppCoda")
            .font(.subheadline)
            .foregroundColor(.blue)
                        
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
