//
//  AuthManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation
import Combine

// is responsible for state management
class AuthManager: ObservableObject {
    
    @Published var userSession: String?
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
        self.userSession = service.getUserSession()
    }
    
    func login(with email: String, password: String) async throws {
        self.userSession = try await service.login(withEmail: email, password: password)
    }
    
    func createUser(withEmail email: String, password: String, usermame: String) async throws {
        self.userSession = try await service
            .createUser(
                email: email,
                password: password,
                username: usermame
            )
    }
    
    func deleteAccount() async throws {
        
    }
    
    func sendresetPasswordLink(toEmail email: String) async throws {
        
    }
    
    func validateEmail(_ email: String) async throws -> Bool {
        return try await service.validateEmail(email)
    }
    
    func validateUsername(_ username: String) async throws -> Bool {
        return try await service.validateUsername(username)
    }
    
    func signOut() async throws {
        try await service.signOut() // signs out on BE
        userSession = nil // signs out on client and updates state
    }
}
