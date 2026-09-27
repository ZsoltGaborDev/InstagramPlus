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
    }
    
    func like() async throws {
        post.didLike = true
        if let likes = post.likes {
            post.likes! += 1
        }
    }
    
    func unlike() async throws {
        post.didLike = false
        if post.likes ?? 0 > 0 {
            post.likes! -= 1
        }
    }
}
