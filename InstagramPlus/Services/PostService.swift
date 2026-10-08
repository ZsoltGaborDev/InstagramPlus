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

// MARK: - Likes

extension PostService {
    static func likePost(post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        async let _ = try await FirebaseConstant
            .PostsCollection
            .document(post.id)
            .collection("post-likes")
            .document(uid).setData([:])
        async let _ = try await FirebaseConstant
            .PostsCollection
            .document(post.id)
            .updateData(["likes": post.likes != nil ? post.likes! + 1 : 1])
        async let _ = Firestore.firestore().collection("users").document(uid).collection("user-likes").document(post.id).setData([:])
    }
    
    static func unlikePost(post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let likes = post.likes else { return }
        async let _ = try await FirebaseConstant
            .PostsCollection
            .document(post.id)
            .collection("post-likes")
            .document(uid).delete()
        async let _ = try await FirebaseConstant
            .PostsCollection
            .document(post.id)
            .updateData(["likes" : likes - 1])
        async let _ = FirebaseConstant
            .UsersCollection
            .document(uid)
            .collection("user-likes")
            .document(post.id).delete()
    }
    
    static func checkIfUserLikedPost(post: Post) async throws -> Bool {
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
