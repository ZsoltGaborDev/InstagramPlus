//
//  PostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 26/09/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostService {
    
    private static let userService = UserService()
    
    static func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await FirebaseConstant
            .PostsCollection
            .getDocuments()
        var posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})
        
        for i in 0..<posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid
            let postUser = try await userService.fetchUser(withUid: ownerUid)
            posts[i].user = postUser
        }
        return posts
    }
    
    static func fetchProfilePosts(uid: String) async throws -> [Post] {
        let snapshot = try await FirebaseConstant
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: Post.self)})
    }
    
    static func fetchPost(_ postId: String) async throws -> Post {
        return try await FirebaseConstant
            .PostsCollection.document(postId)
            .getDocument(as: Post.self)
    }
}
    
