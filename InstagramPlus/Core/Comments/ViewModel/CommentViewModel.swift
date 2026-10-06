//
//  CommentViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation
import FirebaseAuth
import Firebase

@Observable
class CommentViewModel {
    var comments = [Comment]()
    
    private let post: Post
    private let commentService: CommentServiceProtocol
    private let userService: UserServiceProtocol
    
    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol) {
        self.post = post
        self.userService = userService
        self.commentService = commentService
        
        Task { try await fetchComments() }
    }
    
    func uploadComment(text: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let comment = Comment(
            id: UUID().uuidString,
            ownerUid: uid,
            text: text,
            postId: post.id,
            postOwnerUid: post.ownerUid,
            timestamp: Date())
        
        try await commentService.uploadComment(comment)
        try await fetchComments()
        
        IGNotificationsManager.shared.uploadCommentNotification(to: post.ownerUid, post: post)
    }
    
    func fetchComments() async throws {
        self.comments = try await commentService.fetchComments()
        try await fetchDataForComments()
    }
    
    private func fetchDataForComments() async throws {
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let user = try await userService.fetchUser(withUid: comment.ownerUid)
            comments[i].user = user
        }
    }
}

