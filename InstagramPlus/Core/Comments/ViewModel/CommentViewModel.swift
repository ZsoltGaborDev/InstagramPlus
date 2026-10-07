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
    
    func fetchComments() async {
        do {
            let tempComments = try await commentService.fetchComments()
            let result = try await fetchDataForComments(tempComments)
            self.comments = result
        } catch {
            print("DEBUG: Failed to fetch comments with error \(error)")
        }
    }
    
    private func fetchDataForComments(_ comments: [Comment]) async throws -> [Comment] {
        var result = comments
        
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self = self else {return}
            
            for (index, comment) in comments.enumerated() {
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: comment.commentOwnerUid)
                    return (index, user)
                }
            }
            
            for try await (index, user) in group {
                result[index].user = user
            }
        }
        return result
    }
}

