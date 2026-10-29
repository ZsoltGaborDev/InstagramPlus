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
        
    }
    
    func reject (_ request: FollowRequest) async throws {
        
    }
    
    func removeFollowRequest (_ request: FollowRequest) async throws {
        
    }
}
