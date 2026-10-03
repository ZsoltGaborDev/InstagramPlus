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
    var error: Error?
    
    func login(with authManager: AuthManager) async {
        do {
            try await authManager.login(with: email, password: password)
        } catch {
            self.error = error
        }
    }
}
