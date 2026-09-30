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
    
    private let service: IGNotificationService
    
    init(service: IGNotificationService) {
        self.service = service
        Task { await fetchNotifications() }
    }
    
    func fetchNotifications() async {
        do {
            self.notifications = try await service.fetchNotifications()
            try await updateNotifications()
        } catch {
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
    
    private func updateNotifications() async throws {
        for index in notifications.indices {
            var notification = notifications[index]
            
            let senderUid = notification.notificationSenderUid
            let postId = notification.postId

            async let fetchedUser: User? = try? await UserService.fetchUser(
                withUid: senderUid
            )

            async let fetchedPost: Post? = {
                guard let postId = postId else { return nil }
                return try? await PostService.fetchPost(postId)
            }()

            let (user, post) = await (fetchedUser, fetchedPost)

            notification.user = user
            notification.post = post

            notifications[index] = notification
        }
    }
}
