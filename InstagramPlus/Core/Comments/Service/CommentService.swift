//
//  CommentService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation
import FirebaseFirestore
import Firebase

protocol CommentServiceProtocol {
    func uploadComment(_ comment: Comment) async throws
    func fetchComments() async throws -> [Comment]
    
    var postId: String { get }
}

struct CommentService: CommentServiceProtocol {
    
    let postId: String
    
    func uploadComment(_ comment: Comment) async throws {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        
        try await FirebaseConstant
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .addDocument(data: commentData)
    }
    
    func fetchComments() async throws -> [Comment] {
        let comments = try await FirebaseConstant
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .order(by: "timestamp", descending: true)
            .getDocuments()
            .documents
            .compactMap({ try $0.data(as: Comment.self) })
        
        return comments
    }
}
