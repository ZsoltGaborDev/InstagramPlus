//
//  Post.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import Foundation
struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String
    var likes: Int?
    let imageUrl: String
    let timestamp: Date

    var user: User?
    var didLike: Bool?

    enum CodingKeys: String, CodingKey {
        case id, ownerUid, caption, likes, imageUrl, timestamp
    }
}
