//
//  User.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
    
    var isFollowed: Bool?
    var stats: UserStats?
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

struct UserStats: Hashable, Codable {
    var followingCount: Int
    var followersCount: Int
    var postsCount: Int
}
