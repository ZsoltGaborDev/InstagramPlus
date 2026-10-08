//
//  FeedViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 26/09/2026.
//

import Foundation
import SwiftUI

@Observable
class FeedViewModel {

    var posts = [Post]()
    var loadingState: ContentLoadingState = .loading
    
    private let feedService: FeedServiceProtocol
    private let userService: UserServiceProtocol
    
    init(feedService: FeedServiceProtocol, userService: UserServiceProtocol) {
        self.feedService = feedService
        self.userService = userService
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async {
        do {
            self.posts = try await feedService.fetchFeedPosts()
            let result = try await fetchPostUserData(posts: posts)
            self.posts = result
            self.loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
        }
    }
    
    private func fetchPostUserData(posts: [Post]) async throws -> [Post] {
        var result = posts
        
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self else {return}
            for (index, post) in posts.enumerated() {
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: post.ownerUid)
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

extension FeedViewModel {
    
    func like(_ post: Post) async throws {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            if let likes = self.posts[index].likes {
                self.posts[index].likes = likes + 1
            } else {
                self.posts[index].likes = 1
            }
            self.posts[index].didLike = true
            try await feedService.like(post)
        } catch {
            posts[index].didLike = false
            if posts[index].likes ?? 0 > 0 {
                posts[index].likes! -= 1
            }
        }
    }
    
    func unlike(_ post: Post) async throws {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            if posts[index].likes ?? 0 > 0 {
                posts[index].likes! -= 1
            }
            self.posts[index].didLike = false
            try await feedService.unlike(post)
        } catch {
            posts[index].didLike = true
            if let _ = post.likes {
                posts[index].likes! += 1
            }
        }
    }
    
    func checkIfUserLikedPost(_ post: Post) async  {
        guard post.didLike != nil else {return}
        
        do {
            guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
            self.posts[index].didLike = try await feedService.checkIfUserLikedPost(post)
        } catch {
            print("DEBUG: Failed check if user liked the post with error \(error)")
        }
    }
}
