//
//  IGNOtificationsManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation

struct IGNotificationsManager {
    
    private let service: IGNotificationManagementServiceProtocol
    
    init(service: IGNotificationManagementServiceProtocol) {
        self.service = service
    }
    
    func uploadLikeNotification(to uid: String, post: Post) async throws {
        do {
            try await service.uploadNotifications(toUid: uid, type: .like, post: post)
        } catch {
            print("DEBUG: Failed upload like notifications with error: \(error)")
        }
    }
    
    func uploadCommentNotification(to uid: String, post: Post) async throws {
        do {
            try await service.uploadNotifications(toUid: uid, type: .comment, post: post)
        } catch {
            print("DEBUG: Failed upload comment notifications with error: \(error)")
        }
    }
    
    func uploadFollowNotification(to uid: String) async throws {
        do {
            try await service.uploadNotifications(toUid: uid, type: .follow, post: nil)
        } catch {
            print("DEBUG: Failed upload follow notifications with error: \(error)")
        }
    }
    
    func uploadFollowRequestAcceptedNotification(toUid uid: String) async throws {
        do {
            try await service.uploadNotifications(toUid: uid, type: .followRequestAccepted, post: nil)
        } catch {
            print("DEBUG: Failed upload follow request accepted notifications with error: \(error)")
        }
    }
    
    func deleteLikeNotification(notificationOwnerUid: String, post: Post) async {
        do {
            try await service.deleteNotification(toUid: notificationOwnerUid, type: .like, post: post)
        } catch {
            print("DEBUG: Failed to delete like notification")
        }
    }
    
    func deleteFollowNotification(notificationOwnerUid: String) async {
        do {
            try await service.deleteNotification(toUid: notificationOwnerUid, type: .follow, post: nil)
        } catch {
            print("DEBUG: Failed to delete follow notification")
        }
    }
}
