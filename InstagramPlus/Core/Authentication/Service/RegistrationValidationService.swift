//
//  RegistrationValidationService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 06/10/2026.
//

import Foundation
import Firebase

protocol RegistrationValidationProtocol {
    func validateEmail(_ email: String) async throws -> Bool
    func validateUsername(_ username: String) async throws -> Bool
}

struct RegistrationValidationService: RegistrationValidationProtocol {
    
    func validateEmail(_ email: String) async throws -> Bool {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        if !snapshot.isEmpty {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return snapshot.isEmpty
    }
    
    func validateUsername(_ username: String) async throws -> Bool {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        if !snapshot.isEmpty {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return snapshot.isEmpty
    }
}

class MockRegistrationValidationService: RegistrationValidationProtocol {
    func validateEmail(_ email: String) async throws -> Bool {
        return email.isValidEmail()
    }
    
    func validateUsername(_ username: String) async throws -> Bool {
        return username.isValidUsername()
    }
}
