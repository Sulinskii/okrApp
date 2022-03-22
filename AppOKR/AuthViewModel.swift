//
//  SignUpViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    
    private let auth = Auth.auth()

    @Published var signedIn: Bool = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    @Published var isValid = false
    
    @Published var inlineErrorForEmail = ""
    @Published var inlineErrorForPassword = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    private let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
    
    private var isEmailValidPublisher: AnyPublisher<EmailStatus, Never> {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {
                return self.emailPredicate.evaluate(with: $0) ? .valid : .notValid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { self.passwordPredicate.evaluate(with: $0) }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongPublisher)
            .map {
                if $0 { return PasswordStatus.empty }
                else if !$1 { return PasswordStatus.repeatedPasswordWrong }
                else if !$2 { return PasswordStatus.notStrongEnough }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
            .map { $0 == .valid && $1 == .valid}
            .eraseToAnyPublisher()
    }
    
    lazy var isSignedIn: Bool = {
        auth.currentUser != nil
    }()
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
        
        isEmailValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { $0.errorMessage() }
            .assign(to: \.inlineErrorForEmail, on: self)
            .store(in: &cancellables)
        
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { $0.errorMessage() }
            .assign(to: \.inlineErrorForPassword, on: self)
            .store(in: &cancellables)
    }

    public func signIn() {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }

    public func signUp() {
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
