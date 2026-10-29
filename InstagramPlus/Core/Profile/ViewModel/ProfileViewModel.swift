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
    private let followService: FollowServiceProtocol
    
    init(user: User, followService: FollowServiceProtocol) {
        self.user = user
        self.followService = followService
    }
}

//MARK: - Following
extension ProfileViewModel {
    func follow() {
        Task {
            do {
                user.isFollowed = true
                try await followService.follow(uid: user.id)
                IGNotificationsManager.shared.uploadFollowNotification(to: user.id)
            } catch {
                user.isFollowed = false
                print("DEBUG: Failed follow user")
            }
        }
    }
    
    func unfollow() {
        Task {
            do {
                user.isFollowed = false
                try await followService.unfollow(uid: user.id)
                await IGNotificationsManager.shared.deleteFollowNotification(notificationOwnerUid: user.id)
            } catch {
                user.isFollowed = true
                print("DEBUG: Failed unFollow user")
            }
        }
    }
    
    func checkIfUserIsFollowed() async {
        guard user.isFollowed == nil else { return }
        do {
            self.user.isFollowed = try await followService.checkIfUserIsFollowed(uid: user.id)
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
