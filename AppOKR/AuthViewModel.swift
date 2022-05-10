//
//  SignUpViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import FirebaseAuth
import Combine
import CoreData

final class AuthViewModel: ObservableObject {
    
    @Published var signedIn: Bool = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    @Published var isValid = false
    
    @Published var inlineErrorForEmail = ""
    @Published var inlineErrorForPassword = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let auth = Auth.auth()
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    private let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
    
    private var isEmailValidPublisher: AnyPublisher<EmailStatus, Never> {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] in
                guard let self = self else { return .notValid }
                return self.emailPredicate.evaluate(with: $0) && $0.count > 4 ? .valid : .notValid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { $0 == $1 || $1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { [weak self] in
                self?.passwordPredicate.evaluate(with: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongPublisher)
            .dropFirst()
            .map {
                if $0 { return .empty }
                else if !$1 { return .repeatedPasswordWrong }
                else if !$2 { return .notStrongEnough }
                return .valid
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
            .sink(receiveValue: { [weak self] isFormValid in
                self?.isValid = isFormValid
            })
            .store(in: &cancellables)
        
        isEmailValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { $0.errorMessage() }
            .sink(receiveValue: { [weak self] isEmailValid in
                self?.inlineErrorForEmail = isEmailValid
            })
            .store(in: &cancellables)
        
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { $0.errorMessage() }
            .sink(receiveValue: { [weak self] isPasswordValid in
                self?.inlineErrorForPassword = isPasswordValid
            })
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
        CoreDataStack.delete()
        try? auth.signOut()
        signedIn = false
    }
}
