//
//  Comment.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import Foundation

struct Comment: Identifiable, Hashable, Codable {
    let id: String
    let commentOwnerUid: String
    let text: String
    let postId: String
    let postOwnerUid: String
    let timestamp: Date

    // Dati caricati separatamente: non vengono salvati nel documento Comment.
    var user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case commentOwnerUid
        case text = "commentText"
        case postId
        case postOwnerUid
        case timestamp
    }
}
