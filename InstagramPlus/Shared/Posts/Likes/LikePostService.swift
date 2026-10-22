//
//  LikePostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 14/10/2026.
//

import Firebase
import FirebaseAuth

protocol LikePostServiceProtocol {
    func likePost(_ post: Post) async throws
    func unlikePost(_ post: Post) async throws
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool
}

struct LikePostService: LikePostServiceProtocol {
    private let cache = LikesCache.shared
    
    func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstant.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikesRef = FirebaseConstant.UserLikesCollection(uid: uid).document(post.id)
        
        batch.setData([:], forDocument: postLikesRef)
        batch.setData([:], forDocument: userLikesRef)
        batch.updateData(["likes": FieldValue.increment(Int64(1))], forDocument: postRef)
        
        try await batch.commit()
        cache.update(post.id, didAdd: true)
    }
    
    func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstant.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikesRef = FirebaseConstant.UserLikesCollection(uid: uid).document(post.id)
        
        batch.deleteDocument(postLikesRef)
        batch.deleteDocument(userLikesRef)
        batch.updateData(["likes": FieldValue.increment(Int64(-1))], forDocument: postRef)
        
        try await batch.commit()
        cache.update(post.id, didAdd: false)
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return cache.contains(post.id)
    }
}
