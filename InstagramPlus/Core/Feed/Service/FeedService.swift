//
//  FeedService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FeedServiceProtocol {
    func fetchFeedPosts() async throws -> [Post]
    func refreshPosts() async throws -> [Post]
}

class FeedService: FeedServiceProtocol {
    
    private var lastDoc: QueryDocumentSnapshot?
    private var shouldLoadMoreData = true
    private var fetchLimit = 5
    
    func fetchFeedPosts() async throws -> [Post] {
        let postIDs = try await fetchPostIDs()
        return try await fetchPosts(with: postIDs)
    }
    
    func refreshPosts() async throws -> [Post] {
        self.lastDoc = nil
        shouldLoadMoreData = true
        return try await fetchFeedPosts()
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
