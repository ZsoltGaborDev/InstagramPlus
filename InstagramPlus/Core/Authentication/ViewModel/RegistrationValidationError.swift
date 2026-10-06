//
//  RegistrationValidationError.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 06/10/2026.
//

import Foundation

enum RegistrationValidationError: Error {
    case emailValidationFailed
    case usernameValidationFailed
    case invalidUsernameFormat
    case invalidEmailFormat
    case unknown
    case networkError
}

extension RegistrationValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailValidationFailed:
            "This email is already in use.Please try again"
        case .usernameValidationFailed:
            "This username is already in use.Please try again"
        case .invalidUsernameFormat:
            "Username format is invalid. Please try again"
        case .invalidEmailFormat:
            "Email entered is invalid. Please try again"
        case .unknown:
            "Unknown error occured. Please try again,"
        case .networkError:
            "A Network error occured. Please try again."
        }
    }
}
