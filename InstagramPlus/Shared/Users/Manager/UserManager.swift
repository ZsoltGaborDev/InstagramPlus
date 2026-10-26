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
            self.currentUser?.stats = try await UserService.fetchUserStats(uid: uid)
        } catch {   
            print("DEBUG: Failed fetcing user stats")
        }
    }
}
