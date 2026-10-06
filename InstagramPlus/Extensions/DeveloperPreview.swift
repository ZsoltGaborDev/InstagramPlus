//
//  DeveloperPrevoewMockData.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Firebase
import SwiftUI


let dev = DeveloperPreview.shared

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let comment = Comment(id: "8888", commentOwnerUid: "123", text: "Test comment", postId: "321", postOwnerUid: "123456789", timestamp: Date())
    
    let notifications: [IGNotification] = [
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "123", type: .like),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "456", type: .comment),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "789", type: .comment),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "098", type: .follow),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "765", type: .like),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "543", type: .like),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "321", type: .follow)
        
    ]
}
