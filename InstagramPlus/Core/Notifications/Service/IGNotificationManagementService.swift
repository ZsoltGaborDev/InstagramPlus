//
//  IGNotificationManagementService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 04/11/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


protocol IGNotificationManagementServiceProtocol {
    func uploadNotifications(toUid uid: String, type: IGNotificationType, post: Post?) async throws
    func deleteNotification(toUid uid: String, type: IGNotificationType, post: Post?) async throws
}

struct IGNotificationManagementService: IGNotificationManagementServiceProtocol {
    
    func uploadNotifications(toUid uid: String, type: IGNotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid, currentUid != uid else { return }
        let ref = FirebaseConstant.UserNotificationCollection(uid: uid).document()
        let notification = IGNotification(id: ref.documentID,
                                          postId: post?.id,
                                          timestamp: Date(),
                                          notificationSenderUid: currentUid,
                                          type: type)
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        try await ref.setData(notificationData)
    }
    
    func deleteNotification(toUid uid: String, type: IGNotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let notifications = try await FirebaseConstant
            .UserNotificationCollection(uid: uid)
            .whereField("notificationSenderUid", isEqualTo: currentUid)
            .getDocuments(as: IGNotification.self)
        
        let filteredByType = notifications.filter({ $0.type == type }) // gets all notifications by type
        
        if type == .follow {
            for notification in filteredByType {
                try await FirebaseConstant
                    .UserNotificationCollection(uid: uid)
                    .document(notification.id)
                    .delete()
            }
        } else {
            guard let notificationToDelete = filteredByType.first(where: { $0.postId == post?.id }) else { return } // gets notification for that post
            
            try await FirebaseConstant
                .UserNotificationCollection(uid: uid)
                .document(notificationToDelete.id)
                .delete()
        }
    }
}
