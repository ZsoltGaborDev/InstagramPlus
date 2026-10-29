//
//  FollowRequest.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/10/2026.
//

import Foundation


struct FollowRequest: Codable, Identifiable {
    let id: String
    let toUserId: String
    let fromUserId: String
    let timestamp: Date
    
    var user: User?
}
