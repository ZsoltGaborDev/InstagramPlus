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
        Task { try await UserService.unfollow(uid: user.id)
            user.isFollowed = false
        
            await IGNotificationsManager.shared.deleteFollowNotification(notificationOwnerUid: user.id)
        }
    }
    
    func checkIfUserIsFollowed() async {
        do {
            self.user.isFollowed = try await UserService.checkIfUserIsFollowed(uid: user.id)
        } catch {
            print("DEBUG: Failed check user followed value with error: \(error)")
        }
    }
    
    func fetchUserStats() async {
        guard user.stats == nil else { return }
        
        do {
            self.user.stats = try await UserService.fetchUserStats(uid: user.id)
        } catch {
            print("DEBUG: Failed to fetch user stats with error: \(error)")
        }
    }
}
