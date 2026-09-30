//
//  IGNotificationType.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation

enum IGNotificationType: Int, Codable {
    case like
    case comment
    case follow
    
    var notificationMessage: String {
        switch self {
        case .like: return "liked one of your posts."
        case .comment: return "commented one of your posts."
        case .follow: return "started to follow you."
        }
    }
}
