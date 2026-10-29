//
//  UserRelationState.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/10/2026.
//

import Foundation

enum UserRelationState: Codable {
    case unknown
    case isCurrentUser
    case notFollowed
    case followed
    case requestedToFollow
    case blocked
}
