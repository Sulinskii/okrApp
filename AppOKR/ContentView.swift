//
//  ContentView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = BooksViewModel()
    
    var body: some View {
        VStack {
            if authViewModel.signedIn {
                DashboardView(viewModel: viewModel)
            } else {
                SignInView()
            }
        }.onAppear {
            authViewModel.signedIn = authViewModel.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
