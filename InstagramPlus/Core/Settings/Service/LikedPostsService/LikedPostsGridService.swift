//
//  SavedPostsGridService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//


import Foundation
import FirebaseAuth
import Firebase

struct LikedPostsGridService: PostGridServiceProtocol {
    
    func fetchPost() async throws -> [Post] {
        let likedPostsIDs = try await fetchPostIDs()
        
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
        
        let snapshot = try await FirebaseConstant
            .UserLikesCollection(uid: uid)
            .getDocuments()
        
        return snapshot.documents.map { $0.documentID }
    }
}
