//
//  AuthManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation
import SwiftUI
import UIKit

// is responsible for state management
@Observable
class AuthManager {
    
    var userSession: String?
    private let service: AuthService?
    
    init(service: AuthService) {
        self.service = service
    }
    
    func login(with email: String, password: String) async throws {
        
    }
    
    func createUser(withEmail email: String, password: String, usermame: String) async throws -> User? {
        return nil
    }
    
    func deleteAccount() async throws {
        
    }
    
    func sendresetPasswordLink(toEmail email: String) async throws {
        
    }
    
    func signOut() {
        
    }
}
