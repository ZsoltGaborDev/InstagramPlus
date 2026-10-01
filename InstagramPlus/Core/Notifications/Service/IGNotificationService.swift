//
//  IGNotificationServoce.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class IGNotificationService {
    
    func fetchNotifications() async throws -> [IGNotification] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await FirebaseConstant
            .UserNotificationCollection(uid: currentUid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: IGNotification.self) })
    }
    
    func uploadNotifications(toUid uid: String, type: IGNotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid, currentUid != uid else { return }
        let ref = FirebaseConstant.UserNotificationCollection(uid: uid).document()
        let notification = IGNotification(id: ref.documentID,
                                          postId: post?.id,
                                          timestamp: Timestamp(),
                                          notificationSenderUid: currentUid,
                                          type: type)
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        ref.setData(notificationData)
    }
    
    func deleteNotification(toUid uid: String, type: IGNotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await FirebaseConstant
            .UserNotificationCollection(uid: uid)
            .whereField("notificationSenderUid", isEqualTo: currentUid)
            .getDocuments()
        
        let notifications = snapshot.documents.compactMap({ try? $0.data(as: IGNotification.self) })
        
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
