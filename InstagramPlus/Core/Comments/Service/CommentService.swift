//
//  CommentService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth

protocol CommentServiceProtocol {
    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment
    func fetchComments() async throws -> [Comment]
    
    var postId: String { get }
}

struct CommentService: CommentServiceProtocol {
    
    let postId: String
    
    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment {
        guard let currentUid = Auth.auth().currentUser?.uid else { throw UserError.invalidUserId }
        
        let ref = FirebaseConstant
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .document()
        
        let comment = Comment(
            id: ref.documentID,
            commentOwnerUid: currentUid,
            text: commentText,
            postId: postId,
            postOwnerUid: postOwnerUid,
            timestamp: Date())
        
        let commentData = try Firestore.Encoder().encode(comment)
        try await ref.setData(commentData)
        
        return comment
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
