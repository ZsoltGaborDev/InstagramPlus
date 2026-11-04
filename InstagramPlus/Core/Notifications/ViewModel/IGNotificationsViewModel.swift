//
//  IGNotificationsViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI

@Observable
class IGNotificationsViewModel {
    
    var notifications = [IGNotification]()
    var loadingState: ContentLoadingState = .loading
    
    private var isInitialLoad = true
    
    private let service: IGNotificationFetchingService
    private let userService: UserServiceProtocol
    private let followService: FollowServiceProtocol
    private var currentUser: User?
    
    init(service: IGNotificationFetchingService, userService: UserServiceProtocol, followService: FollowServiceProtocol) {
        self.service = service
        self.userService = userService
        self.followService = followService
        Task { await fetchNotifications() }
        
        self.currentUser = nil
    }
    
    func fetchNotifications() async {
        guard isInitialLoad else {return}
        do {
            let result = try await service.fetchNotifications()
            let completeNotifications = try await updateNotifications(result)
            self.notifications = completeNotifications
            loadingState = notifications.isEmpty ? .empty : .complete
            isInitialLoad.toggle()
        } catch {
            loadingState = .error
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
    
    func refreshNotifications() async {
        isInitialLoad = true
        loadingState = .loading
        await fetchNotifications()
    }
    
    private func updateNotifications(_ notifications: [IGNotification]) async throws -> [IGNotification] {
        var result = notifications
        
        try await withThrowingTaskGroup(of: (Int, IGNotification).self) { [weak self] group in
            guard let self = self else {return}
            for (index, notification) in notifications.enumerated() {
                group.addTask {
                    var updatedNotification = notification
                    
                    async let user = self.userService.fetchUser(withUid: notification.notificationSenderUid)
                    
                    async let relationState = notification.type == .follow
                    ? self.followService.fetchUserRelationState(uid: notification.notificationSenderUid)
                    : nil
                    
                    async let post = notification.postId != nil
                    ? PostService.fetchPost(notification.postId!)
                    : nil
                    
                    updatedNotification.user = try await user
                    updatedNotification.post = try await post
                    updatedNotification.user?.userRelationState = try await relationState ?? .unknown
                    
                    return (index, updatedNotification)
                }
                
                for try await (index, notification) in group {
                    result[index] = notification
                }
            }
        }
        
        return result
    }
}

extension IGNotificationsViewModel {
    func follow(for notification: IGNotification, index: Int?) {
        guard let index = index else {return}
        Task {
            let previousState = notifications[index].user?.userRelationState ?? .unknown
            do {
                notifications[index].user?.userRelationState = .followed
                try await followService.follow(uid: notification.notificationSenderUid)
            } catch {
                notifications[index].user?.userRelationState = previousState
                print("DEBUG: Failed follow user for notification with error: \(error)")
            }
        }
    }
    
    func unfollow(for notification: IGNotification, index: Int?) {
        guard let index = index else {return}
        Task {
            let previousState = notifications[index].user?.userRelationState ?? .unknown
            
            do {
                notifications[index].user?.userRelationState = .notFollowed
                try await followService.unfollow(uid: notification.notificationSenderUid)
            } catch {
                notifications[index].user?.userRelationState = previousState
                print("DEBUG: Failed unfollow user for notification with error: \(error)")
            }
        }
    }
}
