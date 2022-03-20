//
//  SignUpViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import FirebaseAuth

public class SignInViewModel: ObservableObject {
    private let auth = Auth.auth()
    
    var isSignedIn: Bool {
        auth.currentUser != nil
    }
    
    @Published var signedIn: Bool = false
    
    public func signIn(with email: String, and password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            self?.signedIn = false
        }
    }
    
    public func signUp(with email: String, and password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            self?.signedIn = false
        }
    }
}
