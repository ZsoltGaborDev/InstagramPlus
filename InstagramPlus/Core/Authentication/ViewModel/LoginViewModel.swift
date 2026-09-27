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
    
    func signIn() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
