//
//  MockFeedService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 16/10/2026.
//

import Foundation

class MockFeedService: FeedServiceProtocol {
    
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
}
