//
//  SignUpView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct SignInView: View {    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationView {
            VStack {
                Image("MainIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Sign In") {
                        viewModel.signIn()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    
                    NavigationLink("Create account", destination: SignUpView())
                }
            }
            .navigationTitle("Sign In")
            .onAppear {
                viewModel.email = ""
                viewModel.password = ""
                viewModel.passwordAgain = ""
            }
            .alert(isPresented: $viewModel.presentErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text("Please try again"),
                      dismissButton: .default(Text("OK"),
                                              action: {
                    viewModel.presentErrorAlert = false
                }))
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .environmentObject(AuthViewModel())
        }
    }
}
