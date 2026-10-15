//
//  FeedService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FeedServiceProtocol: LikePostServiceProtocol, SavedPostsServiceProtocol {
    func fetchFeedPosts() async throws -> [Post]
    func refreshPosts() async throws -> [Post]
}

class FeedService: FeedServiceProtocol {
    
    private var lastDoc: QueryDocumentSnapshot?
    private var shouldLoadMoreData = true
    private var fetchLimit = 5
    
    private let likePostService: LikePostServiceProtocol
    private let savedPostsService: SavedPostsServiceProtocol
    
    init(likePostService: LikePostServiceProtocol, savedPostsService: SavedPostsServiceProtocol) {
        self.likePostService = likePostService
        self.savedPostsService = savedPostsService
    }
    
    internal func fetchFeedPosts() async throws -> [Post] {
        let postIDs = try await fetchPostIDs()
        return try await fetchPosts(with: postIDs)
    }
    
    func refreshPosts() async throws -> [Post] {
        self.lastDoc = nil
        shouldLoadMoreData = true
        return try await fetchFeedPosts()
    }
    
    func likePost(_ post: Post) async throws {
        try await likePostService.likePost(post)
        IGNotificationsManager.shared.uploadLikeNotification(to: post.ownerUid, post: post)
    }
    
    func unlikePost(_ post: Post) async throws {
        try await likePostService.unlikePost(post)
        await IGNotificationsManager.shared.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return try await likePostService.checkIfUserLikedPost(post)
    }
    
    func savePost(_ post: Post) async throws {
        try await savedPostsService.savePost(post)
    }
    
    func unsavePost(_ post: Post) async throws {
        try await savedPostsService.unsavePost(post)
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return try await savedPostsService.checkIfUserSavedPost(post)
    }
}


private extension FeedService {
    
    func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstant
            .UserFeedCollection(uid: uid)
            .limit(to: fetchLimit)
        
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // fetch next batch posts
            let next = query.start(afterDocument: lastDoc)
            snapshot = try await next.getDocuments()
            shouldLoadMoreData = snapshot.documents.last != nil
            
            if let lastId = snapshot.documents.last {
                self.lastDoc = lastId
            }
        } else {
            // first time fetching
            snapshot = try await query.getDocuments()
            shouldLoadMoreData = snapshot.documents.count == fetchLimit
            lastDoc = snapshot.documents.last
        }
        
        return snapshot.documents.map({ $0.documentID })
    }
    
    func fetchPosts(with postIDs: [String]) async throws -> [Post] {
        var result = [Post]()
        
        try await withThrowingTaskGroup(of: Post.self) { group in
            for id in postIDs {
                group.addTask {
                    return try await PostService.fetchPost(id)
                }
            }
            
            for try await post in group {
                result.append(post)
            }
        }
        return result.sorted(by: { $0.timestamp > $1.timestamp})
    }
}
