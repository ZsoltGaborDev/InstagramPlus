//
//  SavedPostsGridService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//


import Foundation

class LikedPostsGridService: PostGridServiceProtocol {
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var indexOfLastFetchedPost = 0
    private lazy var postIds = LikesCache.shared.getData()
    
    func fetchPost() async throws -> [Post] {
        let likedPostsIDs = fetchPostIdsFromCache()
        if likedPostsIDs.isEmpty { return [] }
        
        var result = [Post]()
        
        try await withThrowingTaskGroup(of: Post.self) { group in
            for likedPostsId in likedPostsIDs {
                group.addTask {
                    return try await PostService.fetchPost(likedPostsId)
                }
            }
            
            for try await post in group {
                result.append(post)
            }
        }
        
        return result.sorted(by: {$0.timestamp > $1.timestamp})
    }
    
    private func fetchPostIdsFromCache() -> [String] {
        guard shouldLoadMoreData else { return [] }
        
        let startIndex = indexOfLastFetchedPost
        let endIndex = min(startIndex + fetchLimit, postIds.count) // min(0 + 3 = 3, 10) = 3 the minimum between the 3 and 10
        indexOfLastFetchedPost = endIndex
        shouldLoadMoreData = endIndex < postIds.count
        
        return Array(postIds[startIndex ..< endIndex])
    }
}
