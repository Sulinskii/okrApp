//
//  PasswordStatus.swift
//  AppOKR
//
//  Created by Artur Sulinski on 22/03/2022.
//

import Foundation


enum PasswordStatus {
    case empty
    case notStrongEnough
    case repeatedPasswordWrong
    case valid
    
    func errorMessage() -> String {
        switch self {
        case .empty:
            return "Password can't be empty"
        case .notStrongEnough:
            return "Password is not strong enough"
        case .repeatedPasswordWrong:
            return "Passwords don't match"
        case .valid:
            return ""
        }
    }
}

enum EmailStatus {
    case notValid
    case valid
    
    func errorMessage() -> String {
        switch self {
        case .notValid:
            return "Email is not valid"
        case .valid:
            return ""
        }
    }
}
