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
    func like(_ post: Post) async throws
    func unlike(_ post: Post) async throws
    func save(_ post: Post) async throws
    func unsave(_ post: Post) async throws
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool
}

struct FeedService: FeedServiceProtocol {
    
    func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await FirebaseConstant
            .PostsCollection
            .getDocuments()
        let posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})

        return posts
    }
    
    func like(_ post: Post) async throws {
        try await PostService.likePost(post: post)
        IGNotificationsManager.shared.uploadLikeNotification(to: post.ownerUid, post: post)
    }
    
    func unlike(_ post: Post) async throws {
        try await PostService.unlikePost(post: post)
        await IGNotificationsManager.shared.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard post.didLike != nil else { return false }
        return try await PostService.checkIfUserLikedPost(post: post)
    }
    
    func save(_ post: Post) async throws {
        print("DEBUG: save post tapped..")
    }
    
    func unsave(_ post: Post) async throws {
        print("DEBUG: unsave post tapped..")
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
}
