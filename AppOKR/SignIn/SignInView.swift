//
//  SignUpView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import SwiftUI

struct SignInView: View {
    @State var login: String = ""
    @State var password: String = ""
    let viewModel: SignInViewModel
    
    var body: some View {
        NavigationView {
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
                
                Button(action: {
                    viewModel.signIn(with: login, and: password)
                }, label: {
                    Text("Sign In")
                        .foregroundColor(.black)
                        .background(Color.blue)
                        .frame(width: 200, height: 50, alignment: .center)
                        .cornerRadius(8)
                })
                .navigationTitle("Sign Up")
                Spacer()
                NavigationLink("Create account", destination: SignUpView(viewModel: viewModel))
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView(viewModel: .init())
        }
    }
}
