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
    
    init(post: Post) {
        self.post = post
    }
    
    func uploadComment(text: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let comment = Comment(ownerUid: uid, text: text, postId: post.id, postOwnerUid: post.ownerUid, timestamp: Timestamp())
        
        try await CommentService.uploadComment(comment, postId: post.id)
    }
}
