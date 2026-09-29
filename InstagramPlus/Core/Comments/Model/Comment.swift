//
//  Comment.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import FirebaseFirestore

struct Comment: Identifiable, Hashable, Codable {
    @DocumentID var commentId: String?

    // Stabile anche prima che Firestore assegni il document ID.
    private let localId = UUID().uuidString

    var id: String {
        commentId ?? localId
    }

    let ownerUid: String
    let text: String
    let postId: String
    let postOwnerUid: String
    let timestamp: Timestamp

    // Dati caricati separatamente: non vengono salvati nel documento Comment.
    var user: User?

    enum CodingKeys: String, CodingKey {
        case ownerUid = "commentOwnerUid"
        case text = "commentText"
        case postId
        case postOwnerUid
        case timestamp
    }

    var createdAt: Date {
        timestamp.dateValue()
    }
}
