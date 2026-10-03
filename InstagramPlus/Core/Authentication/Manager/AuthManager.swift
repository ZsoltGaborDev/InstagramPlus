//
//  AuthManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation
import FirebaseAuth
import Firebase
import Combine

// is responsible for state management
class AuthManager: ObservableObject {
    
    @Published var userSession: String?
    @Published var currentUser: User?
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
        self.userSession = service.getUserSession()
        
        Task {
            if let userSession {
                self.currentUser = try await UserService.shared.fetchCurrentuser()
                print("DEBUG: Current user is \(currentUser?.username)")
            }
        }
    }
    
    func login(with email: String, password: String) async throws {
        self.userSession = try await service.login(withEmail: email, password: password)
    }
    
    func createUser(withEmail email: String, password: String, usermame: String) async throws -> User {
        let user = try await service.createUser(email: email, password: password, username: usermame)
        self.currentUser = user
        return user
    }
    
    func deleteAccount() async throws {
        
    }
    
    func sendresetPasswordLink(toEmail email: String) async throws {
        
    }
    
    func signOut() async throws {
        try await service.signOut() // signs out on BE
        userSession = nil // signs out on client and updates state
    }
}
