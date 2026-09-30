//
//  ProfileViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation

@Observable
class ProfileViewModel {

    var user: User
    
    init(user: User) {
        self.user = user
    }
}

//MARK: - Following
extension ProfileViewModel {
    func follow() {
        Task { try await UserService.follow(uid: user.id) }
        user.isFollowed = true
        
        IGNotificationsManager.shared.uploadFollowNotification(to: user.id)
    }
    
    func unfollow() {
        Task { try await UserService.unfollow(uid: user.id) }
        user.isFollowed = false
    }
    
    func checkIfUserIsFollowed() {
        Task {
            self.user.isFollowed = try await UserService.checkIfUserIsFollowed(uid: user.id)
        }
    }
    
    func fetchUserStats() {
        guard user.stats == nil else { return }
        Task {
            self.user.stats = try await UserService.fetchUserStats(uid: user.id)
        }
    }
}
