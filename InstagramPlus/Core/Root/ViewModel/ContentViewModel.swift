//
//  ContentViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import FirebaseAuth

@Observable
class ContentViewModel {
    
    private let service = AuthService.shared
    
    var userSession: FirebaseAuth.User? {
        service.userSession
    }
    
    var currentUser: User? {
        service.currentUser
    }
}
