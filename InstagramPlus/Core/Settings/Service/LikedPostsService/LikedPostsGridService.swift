//
//  SavedPostsGridService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//


import Foundation
import FirebaseAuth
import Firebase

class LikedPostsGridService: PostGridServiceProtocol {
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?
    
    func fetchPost() async throws -> [Post] {
        let likedPostsIDs = try await fetchPostIDs()
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
    
    private func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        
        let query = FirebaseConstant.UserLikesCollection(uid: uid)
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // pagination
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
            
        } else {
            // first pull
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        
        let result = snapshot.documents.map { $0.documentID }
        shouldLoadMoreData = result.count == fetchLimit
        return result
    }
}
