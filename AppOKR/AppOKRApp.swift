//
//  AppOKRApp.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI

@main
struct AppOKRApp: App {
    let viewModel: BooksViewModel = BooksViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
