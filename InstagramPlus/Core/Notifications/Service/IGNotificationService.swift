//
//  IGNotificationServoce.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class IGNotificationService {
    
    func fetchNotifications() async throws -> [IGNotification] {
        return DeveloperPreview.shared.notifications
    }
    
    func uploadNotifications(toUid uid: String, type: IGNotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid, currentUid != uid else { return }
        let ref = FirebaseConstant.IGNotificationCollection.document(uid).collection("user-notifications").document()
        let notification = IGNotification(id: ref.documentID,
                                          postId: post?.id,
                                          timestamp: Timestamp(),
                                          notificationSenderUid: currentUid,
                                          type: type)
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        ref.setData(notificationData)
    }
    
    func deleteNotification(toUid uid: String, type: IGNotificationType, post: Post? = nil) {
        
    }
}
