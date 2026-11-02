//
//  FollowRequestService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/10/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FollowRequestService {    
    func fetchFollowRequest() async throws -> [FollowRequest] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        return try await FirebaseConstant.FollowRequestsCollection(uid: currentUid)
            .getDocuments(as: FollowRequest.self)
    }
    
    func accept (_ request: FollowRequest) async throws {
        try await triggerFollow(from: request.fromUserId)
        try await deleteFollowRequest(request)
    }
    
    func reject (_ request: FollowRequest) async throws {
        try await deleteFollowRequest(request)
    }
    
    func deleteFollowRequest (_ request: FollowRequest) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await FirebaseConstant
            .FollowRequestsCollection(uid: currentUid)
            .document(request.id)
            .delete()
    }
    
    private func triggerFollow(from uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let followingRef = FirebaseConstant
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .document(currentUid)
        
        let followerRef = FirebaseConstant
            .FollowersCollection
            .document(currentUid)
            .collection("user-followers")
            .document(uid)
        
        batch.setData([:], forDocument: followingRef)
        batch.setData([:], forDocument: followerRef)
        
        try await batch.commit()
    }
}
