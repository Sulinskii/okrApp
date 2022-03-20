//
//  AppOKRApp.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI
import Firebase

@main
struct AppOKRApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    let viewModel = SignInViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}


