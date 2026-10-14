//
//  LikePostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 14/10/2026.
//

import Firebase
import FirebaseAuth

protocol LikePostServiceProtocol {
    func likePost(post: Post) async throws
    func unlikePost(post: Post) async throws
    func checkIfUserLikedPost(post: Post) async throws -> Bool
}

struct LikePostService: LikePostServiceProtocol {
    func likePost(post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstant.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikesRef = FirebaseConstant.UserLikesCollection(uid: uid).document(post.id)
        
        batch.setData([:], forDocument: postLikesRef)
        batch.setData([:], forDocument: userLikesRef)
        batch.updateData(["likes": FieldValue.increment(Int64(1))], forDocument: postRef)
        
        try await batch.commit()
    }
    
    func unlikePost(post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstant.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikesRef = FirebaseConstant.UserLikesCollection(uid: uid).document(post.id)
        
        batch.deleteDocument(postLikesRef)
        batch.deleteDocument(userLikesRef)
        batch.updateData(["likes": FieldValue.increment(Int64(-1))], forDocument: postRef)
        
        try await batch.commit()
    }
    
    func checkIfUserLikedPost(post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .collection("user-likes")
            .document(post.id)
            .getDocument()
            .exists
    }
}
