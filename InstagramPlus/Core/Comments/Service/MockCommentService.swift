//
//  MockCommentService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation

class MockCommentService: CommentServiceProtocol {
    var postId: String
    var errorToThrow: Error?
    var shouldTestEmptyState = false

    init(postId: String) {
        self.postId = postId
    }

    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment {
        if let errorToThrow { throw errorToThrow }

        return Comment(
            id: "123",
            commentOwnerUid: "",
            text: commentText,
            postId: "",
            postOwnerUid: postOwnerUid,
            timestamp: Date()
        )
    }

    func fetchComments() async throws -> [Comment] {
        if let errorToThrow { throw errorToThrow }

        if shouldTestEmptyState {
            return []
        } else {
            return MockData.comments
        }
    }
}
