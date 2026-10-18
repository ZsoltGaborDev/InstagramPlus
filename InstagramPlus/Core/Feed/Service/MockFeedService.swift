//
//  MockFeedService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 16/10/2026.
//

import Foundation

class MockFeedService: FeedServiceProtocol {
    private let likePostService: LikePostServiceProtocol
    private let savedPostsService: SavedPostsServiceProtocol
    
    init(likePostService: LikePostServiceProtocol, savedPostsService: SavedPostsServiceProtocol) {
        self.likePostService = likePostService
        self.savedPostsService = savedPostsService
    }
    
    
    func fetchFeedPosts() async throws -> [Post] {
        var result = [Post]()
        let currentUserFollows = [MockData.users[1].id, MockData.users[2].id]
        
        for post in MockData.posts {
            if currentUserFollows.contains(post.ownerUid) {
                result.append(post)
            }
        }
        return result
    }
    
    func refreshPosts() async throws -> [Post] {
        return try await fetchFeedPosts()
    }
    
    func likePost(_ post: Post) async throws {
        try await likePostService.likePost(post)
    }
    
    func unlikePost(_ post: Post) async throws {
        try await likePostService.unlikePost(post)
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
    
    func savePost(_ post: Post) async throws {
        try await savedPostsService.savePost(post)
    }
    
    func unsavePost(_ post: Post) async throws {
        try await savedPostsService.unsavePost(post)
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
}
