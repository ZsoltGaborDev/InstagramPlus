//
//  AuthenticationError.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 04/10/2026.
//

import Foundation

enum AuthenticationError: Error {
    case userDisabled
    case emailAlreadyInUse
    case invalidEmail
    case wrongPassword
    case userNotFound
    case networkError
    case credentialsAlreadyInUse
    case weakPassword
    case unknows
    case invalidCredential
    case tooManyRequests
    
    init(rawValue: Int) {
        switch rawValue {
        case 17004: self = .invalidCredential
        case 17005: self = .userDisabled
        case 17007: self = .emailAlreadyInUse
        case 17008: self = .invalidEmail
        case 17009: self = .wrongPassword
        case 17010: self = .tooManyRequests
        case 17011: self = .userNotFound
        case 17020: self = .networkError
        case 17025: self = .credentialsAlreadyInUse
        case 17026: self = .weakPassword
        default: self = .unknows
        }
    }
}

extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredential: return "The credentials you entered are invalid. Please try again."
        case .userDisabled: return "The account has been disabled"
        case .emailAlreadyInUse: return "This email is already in use. Please login or try again"
        case .invalidEmail: return "The email address entered is invalid. Please try again"
        case .wrongPassword: return "Incorrect password. Please try again"
        case .userNotFound: return "There is no account associated with those credentials. Please try again."
        case .networkError: return "Network error occured. Please try again later"
        case .credentialsAlreadyInUse: return "This credential is already in use. Please try again"
        case .weakPassword: return "Your password is too weak. Please use at least 8 characters, including an uppercase letter, lowercase letter, number, and special character."
        case .unknows: return "Something went wrong. Please try again later."
        case .tooManyRequests: return "Too many unsuccessful attempts. Please wait a few minutes before trying again."
        }
    }
}
