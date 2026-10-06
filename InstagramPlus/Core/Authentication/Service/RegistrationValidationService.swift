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
        let isUnique = try await checkUniqueness(forKey: "email", value: email)
        
        if !isUnique {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return isUnique
    }
    
    func validateUsername(_ username: String) async throws -> Bool {
        let isUnique = try await checkUniqueness(forKey: "username", value: username)
        
        if !isUnique {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return isUnique
    }
    
    private func checkUniqueness(forKey key: String, value: String) async throws -> Bool {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .whereField(key, isEqualTo: value)
            .limit(to: 1)
            .getDocuments()
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
