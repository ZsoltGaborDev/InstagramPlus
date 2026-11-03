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
    
    private let service: IGNotificationService
    private let userService: UserServiceProtocol
    private var currentUser: User?
    
    init(service: IGNotificationService, userService: UserServiceProtocol) {
        self.service = service
        self.userService = userService
        Task { await fetchNotifications() }
        
        self.currentUser = nil
    }
    
    func fetchNotifications() async {
        do {
            let result = try await service.fetchNotifications()
            let completeNotifications = try await updateNotifications(result)
            self.notifications = completeNotifications
            loadingState = notifications.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
    
    private func updateNotifications(_ notifications: [IGNotification]) async throws -> [IGNotification] {
        var result = notifications
        
        try await withThrowingTaskGroup(of: (Int, IGNotification).self) { [weak self] group in
            guard let self = self else {return}
            for (index, notification) in notifications.enumerated() {
                group.addTask {
                    var updatedNotification = notification
                    let user = try await self.userService.fetchUser(withUid: notification.notificationSenderUid)
                    updatedNotification.user = user
                    
                    if let postId = notification.postId {
                        let post = try await PostService.fetchPost(postId)
                        updatedNotification.post = post
                    }
                    
                    if notification.type == .follow {
                        
                    }
                    
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
