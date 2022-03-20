//
//  ContentView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                SignInView(viewModel: viewModel)
            } else {
                DashboardView()
            }
        }.onAppear {
            viewModel.signedIn = viewModel.isSignedIn
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
