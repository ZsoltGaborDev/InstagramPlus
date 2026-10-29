//
//  FollowService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/10/2026.
//

import Foundation
import FirebaseAuth
import Firebase

protocol FollowServiceProtocol {
    func follow(uid: String) async throws
    func unfollow(uid: String) async throws
    func checkIfUserIsFollowed(uid: String) async throws -> Bool
}

struct FollowService: FollowServiceProtocol {
    func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let followingRef = FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
        
        let followerRef = FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
        
        batch.setData([:], forDocument: followingRef)
        batch.setData([:], forDocument: followerRef)
        
        try await batch.commit()
    }
    
    func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let followingRef = FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
        
        let followerRef = FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
        
        batch.deleteDocument(followingRef)
        batch.deleteDocument(followerRef)
        
        try await batch.commit()
    }
    
    func checkIfUserIsFollowed(uid: String) async throws -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return try await FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .getDocument()
            .exists
    }
}
