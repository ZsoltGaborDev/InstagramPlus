//
//  UserManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation

@Observable
class UserManager {
    var currentUser: User?
    
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    func fetchCurrentUser() async {
        do {
            self.currentUser = try await service.fetchCurrentUser()
        } catch {
            print ("DEBUG: Error fetching current user: \(error.localizedDescription)")
        }
    }
    
    func fetchUserStats() async {
        guard let uid = currentUser?.id, currentUser?.stats == nil else { return }
        
        do {
            let stats = try await UserService.fetchUserStats(uid: uid)
            guard currentUser?.id == uid else { return }
            self.currentUser?.stats = stats
        } catch {
            let fetchError = error as NSError
            print("DEBUG: Failed fetching user stats for \(uid): \(fetchError.domain) (\(fetchError.code)): \(fetchError.localizedDescription)")
        }
    }
}
