//
//  SignUpView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("MainIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack {
                TextField("Enter your email address here", text: $login)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Enter your password here", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Sign Up") {
                    viewModel.signUp(with: login, and: password)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .navigationTitle("Sign Up")
    }
}
