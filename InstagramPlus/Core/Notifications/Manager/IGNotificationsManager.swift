//
//  IGNOtificationsManager.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation

class IGNotificationsManager {
    
    static let shared = IGNotificationsManager()
    private let service = IGNotificationService()
    
    func uploadLikeNotification(to uid: String, post: Post) {
        service.uploadNotifications(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(to uid: String, post: Post) {
        service.uploadNotifications(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(to uid: String) {
        service.uploadNotifications(toUid: uid, type: .follow)
    }
}
