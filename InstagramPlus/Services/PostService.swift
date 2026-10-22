//
//  PostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 26/09/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostService {
    
    static func fetchPost(_ postId: String) async throws -> Post {
        return try await FirebaseConstant
            .PostsCollection.document(postId)
            .getDocument(as: Post.self)
    }
}
    
