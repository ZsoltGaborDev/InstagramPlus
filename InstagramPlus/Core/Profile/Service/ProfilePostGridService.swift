//
//  PostGridService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//

import Foundation
import FirebaseAuth

class ProfilePostGridService: PostGridServiceProtocol {
    
    private let user: User?
    
    init(user: User? = nil) {
        self.user = user
    }
    
    func fetchPost() async throws -> [Post] {
        let uid: String
        
        if let user = user {
            uid = user.id
        } else {
            guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
            uid = currentUid
        }
        
        var posts = try await PostService.fetchProfilePosts(uid: uid)
        for i in 0..<posts.count {
            posts[i].user = self.user
        }
        
        return posts
    }
    
    
}
