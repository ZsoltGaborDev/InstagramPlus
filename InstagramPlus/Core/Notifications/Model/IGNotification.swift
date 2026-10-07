//
//  IGNotification.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation

struct IGNotification: Identifiable, Codable {
    let id: String
    var postId: String?
    let timestamp: Date
    let notificationSenderUid: String
    let type: IGNotificationType
    
    var post: Post?
    var user: User?
}
