//
//  AuthManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation

// is responsible for state management
@Observable
class AuthManager {
    
    var userSession: String?
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol) {
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
        try await service.deleteAccount()
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        try await service.sendResetPasswordLink(toEmail: email)
    }
    
    func signOut() async throws {
        try await service.signOut() // signs out on BE
        userSession = nil // signs out on client and updates state
    }
}
