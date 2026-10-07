//
//  FeedService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation
import FirebaseFirestore

protocol FeedServiceProtocol {
    func fetchFeedPosts() async throws -> [Post]
}

struct FeedService: FeedServiceProtocol {
    
    func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await FirebaseConstant
            .PostsCollection
            .getDocuments()
        let posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})

        return posts
    }
}
