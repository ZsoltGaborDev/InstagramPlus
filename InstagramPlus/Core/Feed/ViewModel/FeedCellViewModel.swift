//
//  FeedCellViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 27/09/2026.
//

import Foundation

@Observable
class FeedCellViewModel {
    
    var post: Post
    
    init (post: Post) {
        self.post = post
        Task { try await checkIfUserLikedPost()}
    }
    
    func like() async throws {
        do {
            let postCopy = post
            post.didLike = true
            if let _ = post.likes {
                post.likes! += 1
            }
            try await PostService.likePost(post: postCopy)
            IGNotificationsManager.shared.uploadLikeNotification(to: post.ownerUid, post: post)
        } catch {
            post.didLike = false
            if post.likes ?? 0 > 0 {
                post.likes! -= 1
            }
        }
    }
    
    func unlike() async throws {
        do {
            let postCopy = post
            post.didLike = false
            if post.likes ?? 0 > 0 {
                post.likes! -= 1
            }
            try await PostService.unlikePost(post: postCopy)
        } catch {
            post.didLike = true
            if let _ = post.likes {
                post.likes! += 1
            }
        }
    }
    
    private func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post: post)
    }
}
