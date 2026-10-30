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
            let prevState = user.userRelationState
            do {
                user.userRelationState = .followed
                try await followService.follow(uid: user.id)
                IGNotificationsManager.shared.uploadFollowNotification(to: user.id)
            } catch {
                user.userRelationState = prevState
                print("DEBUG: Failed follow user")
            }
        }
    }
    
    func unfollow() {
        Task {
            let prevState = user.userRelationState
            do {
                user.userRelationState = .notFollowed
                try await followService.unfollow(uid: user.id)
                await IGNotificationsManager.shared.deleteFollowNotification(notificationOwnerUid: user.id)
            } catch {
                user.userRelationState = prevState
                print("DEBUG: Failed unFollow user")
            }
        }
    }
    
    func fetchUserRelationState() async {
        guard user.userRelationState == .unknown else { return }
        do {
            self.user.userRelationState = try await followService.fetchUserRelationState(uid: user.id)
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
    
    func sendFollowRequest() {
        Task {
            let prevState = user.userRelationState
            do {
                user.userRelationState = .requestedToFollow
                try await followService.sendFollowRequest(to: user.id)
            } catch {
                user.userRelationState = prevState
                print("DEBUG: Failed to send request with error: \(error)")
            }
        }
    }
}
