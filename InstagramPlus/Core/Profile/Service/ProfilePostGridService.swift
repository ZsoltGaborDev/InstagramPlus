//
//  PostGridService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfilePostGridService: PostGridServiceProtocol {
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?
    private let user: User?
    
    init(user: User? = nil) {
        self.user = user
    }
    
    func fetchPost() async throws -> [Post] {
        guard let uid = getUserId() else { return [] }
        
        let query = FirebaseConstant
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .limit(to: fetchLimit)
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // pagination
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            // first pull
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        var posts = snapshot.documents.compactMap{ try? $0.data(as: Post.self)}
        
        for i in 0..<posts.count {
            posts[i].user = self.user
        }
        
        
        shouldLoadMoreData = snapshot.count == fetchLimit
        return posts
    }
    
    private func getUserId() -> String? {
        if let user = user {
            return user.id
        } else {
            guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
            return currentUid
        }
    }
    
    
}
