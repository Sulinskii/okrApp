//
//  SignUpViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    private let auth = Auth.auth()

    @Published var signedIn: Bool = false
    
    lazy var isSignedIn: Bool = {
        auth.currentUser != nil
    }()

    public func signIn(with email: String, and password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }

    public func signUp(with email: String, and password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    public func signOut() {
        try? auth.signOut()
        signedIn = false
    }
}
