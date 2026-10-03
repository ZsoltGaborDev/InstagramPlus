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
    var error: Error?
    
    func createUser(with authManager: AuthManager) async {
        do {
            try await authManager.createUser(withEmail: email, password: password, usermame: username)
            reset()
        } catch {
            self.error = error
        }
    }
    
    private func reset() {
        username = ""
        email = ""
        password = ""
    }
}
