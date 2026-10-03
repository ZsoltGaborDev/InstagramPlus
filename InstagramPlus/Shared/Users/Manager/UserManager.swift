//
//  UserManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchCurrentUser() async {
        do {
            self.currentUser = try await service.fetchCurrentUser()
        } catch {
            print ("DEBUG: Error fetching current user: \(error.localizedDescription)")
        }
    }
}
