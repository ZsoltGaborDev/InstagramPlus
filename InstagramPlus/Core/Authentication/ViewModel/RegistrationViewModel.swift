//
//  RegistrationViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import Combine

@Observable
class RegistrationViewModel {
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var isLoading = false
    var isValidating = false
    var showError = false
    var validationError: RegistrationValidationError?
    var authError: AuthenticationError? {
        didSet { showError = authError != nil }
    }
    
    private let service: RegistrationValidationProtocol
    
    init(service: RegistrationValidationProtocol) {
        self.service = service
    }
    
    
    func createUser(with authManager: AuthManager) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authManager.createUser(withEmail: email, password: password, usermame: username)
            reset()
        } catch {
            self.authError = error as? AuthenticationError ?? .unknows
        }
    }
    
    func validateEmail() async -> Bool {
        isValidating = true
        defer { isValidating = false }
        
        do {
            return try await service.validateEmail(email)
        } catch {
            self.validationError = error as? RegistrationValidationError ?? .unknown
            return false
        }
    }
    
    func validateUsername() async -> Bool {
        isValidating = true
        defer { isValidating = false }
        
        do {
            return try await service.validateUsername(username)
        } catch {
            self.validationError = error as? RegistrationValidationError ?? .unknown
            return false
        }
    }
    
    func reset() {
        username = ""
        email = ""
        password = ""
    }
}
