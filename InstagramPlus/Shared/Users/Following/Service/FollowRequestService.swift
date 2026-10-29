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
    func sendFollowRequest(to uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let requestRef = FirebaseConstant.FollowRequestsCollection(uid: uid).document()
        let followRequest = FollowRequest(
            id: requestRef.documentID,
            toUserId: uid,
            fromUserId: currentUid,
            timestamp: Date()
        )
        let data = try Firestore.Encoder().encode(followRequest)
        try await requestRef.setData(data)
    }
    
    func fetchFollowRequest() async throws -> [FollowRequest] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        return try await FirebaseConstant.FollowRequestsCollection(uid: currentUid)
            .getDocuments(as: FollowRequest.self)
    }
    
    func accept (_ request: FollowRequest) async throws {
        
    }
    
    func reject (_ request: FollowRequest) async throws {
        
    }
    
    func removeFollowRequest (_ request: FollowRequest) async throws {
        
    }
}
