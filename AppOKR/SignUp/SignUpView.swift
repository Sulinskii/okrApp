//
//  SignUpView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("MainIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack {
                Form {
                    Section(header: Text("EMAIL"),
                            footer: Text(viewModel.inlineErrorForEmail)
                                .foregroundColor(.red)) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.plain)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    Section(header: Text("PASSWORD"),
                            footer: Text(viewModel.inlineErrorForPassword)
                                .foregroundColor(.red)) {
                        SecureField("Password", text: $viewModel.password)
                        SecureField("Password again", text: $viewModel.passwordAgain)
                    }
                    .textFieldStyle(.plain)
                }
                
                Button("Sign Up") {
                    viewModel.signUp()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .disabled(!viewModel.isValid)
            }
        }
        .navigationTitle("Sign Up")
        .onAppear {
            viewModel.email = ""
            viewModel.password = ""
            viewModel.passwordAgain = ""
        }
    }
}
