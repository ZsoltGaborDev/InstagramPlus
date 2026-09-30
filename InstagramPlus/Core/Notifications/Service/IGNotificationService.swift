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
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await FirebaseConstant
            .UserNotificationCollection(uid: currentUid)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: IGNotification.self) })
    }
    
    func uploadNotifications(toUid uid: String, type: IGNotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid, currentUid != uid else { return }
        let ref = FirebaseConstant.UserNotificationCollection(uid: currentUid).document()
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
