//
//  LoginViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation

@Observable
class LoginViewModel {
    
    var email = ""
    var password = ""
    var showError = false
    var error: AuthenticationError? {
        didSet { showError = error != nil }
    }
    
    func login(with authManager: AuthManager) async {
        do {
            try await authManager.login(with: email, password: password)
        } catch {
            self.error = error as? AuthenticationError ?? .unknows
        }
    }
}
