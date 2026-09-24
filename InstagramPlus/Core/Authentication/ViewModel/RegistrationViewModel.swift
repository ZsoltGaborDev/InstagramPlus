//
//  RegistrationViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import Combine

@Observable
class RegistrationViewModel: ObservableObject {
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(email: email, password: password, username: username)
    }
}
