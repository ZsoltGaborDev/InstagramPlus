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
    private let service: CommentService
    
    init(post: Post, service: CommentService) {
        self.post = post
        self.service = service
        
        Task { try await fetchComments() }
    }
    
    func uploadComment(text: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let comment = Comment(ownerUid: uid, text: text, postId: post.id, postOwnerUid: post.ownerUid, timestamp: Timestamp())
        
        try await service.uploadComment(comment)
        try await fetchComments()
        
        IGNotificationsManager.shared.uploadCommentNotification(to: post.ownerUid, post: post)
    }
    
    func fetchComments() async throws {
        self.comments = try await service.fetchComments()
        try await fetchDataForComments()
    }
    
    private func fetchDataForComments() async throws {
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let user = try await UserService.fetchUser(withUid: comment.ownerUid)
            comments[i].user = user
        }
    }
}

