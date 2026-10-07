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
    
    func uploadComment(text: String, currentUser: User) async throws {
        var comment = try await commentService.uploadComment(
            commentText: text,
            postOwnerUid: post.ownerUid
        )
        
        comment.user = currentUser
        comments.insert(comment, at: 0)
        
        Task {
            IGNotificationsManager.shared.uploadCommentNotification(to: post.ownerUid, post: post)
        }
    }
    
    func fetchComments() async throws {
        self.comments = try await commentService.fetchComments()
        try await fetchDataForComments()
    }
    
    private func fetchDataForComments() async throws {
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self = self else {return}
            
            for (index, comment) in comments.enumerated() {
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: comment.commentOwnerUid)
                    return (index, user)
                }
            }
            
            for try await (index, user) in group {
                self.comments[index].user = user
            }
        }
    }
}

