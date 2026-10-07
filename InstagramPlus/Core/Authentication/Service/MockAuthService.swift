//
//  MockAuthService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    var errorToThrow: AuthenticationError?
    var didCallSignOut = false
    var didCallSendResetPassword = false
    var didCallDeleteAccount = false
    
    func login(withEmail email: String, password: String) async throws -> String {
        if !email.isValidEmail() { throw AuthenticationError.invalidEmail }
        if !password.isValidPassword() { throw AuthenticationError.wrongPassword }
        if let errorToThrow { throw errorToThrow }
        return UUID().uuidString
    }
    
    func createUser(email: String, password: String, username: String) async throws -> String {
        if !email.isValidEmail() { throw AuthenticationError.invalidEmail }
        if !password.isValidPassword() { throw AuthenticationError.wrongPassword }
        if !username.isValidUsername() { throw AuthenticationError.invalidCredential }
        if let errorToThrow { throw errorToThrow }
        return UUID().uuidString
    }
    
    func signOut() async throws {
        didCallSignOut = true
    }
    
    func deleteAccount() async throws {
        didCallDeleteAccount = true
    }
    
    func getUserSession() -> String? {
        return MockData.users[0].id
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        if !email.isValidEmail() { throw AuthenticationError.invalidEmail}
        didCallSendResetPassword = true
    }
}
