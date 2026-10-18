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
    private let likePostService: LikePostServiceProtocol
    let savePostsService: SavedPostsServiceProtocol
    
    init(
        feedService: FeedServiceProtocol,
        userService: UserServiceProtocol,
        likePostService: LikePostServiceProtocol,
        savePostsService: SavedPostsServiceProtocol
    ) {
        self.feedService = feedService
        self.userService = userService
        self.likePostService = likePostService
        self.savePostsService = savePostsService
        
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async {
        do {
            let result = try await feedService.fetchFeedPosts()
            self.posts.append(contentsOf: result)
            let resultWithUserdata = try await fetchPostUserData(posts: posts)
            self.posts = resultWithUserdata
            self.loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
            print("DEBUG: Failed to fetch posts with error: \(error)")
        }
    }
    
    func refreshPosts() async {
        do {
            self.posts.removeAll()
            let result = try await feedService.refreshPosts()
            let resultWithUserdata = try await fetchPostUserData(posts: result)
            self.posts = resultWithUserdata
        } catch {
            print("DEBUG: Failed to refresh posts with error: \(error)")
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
    
    func like(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            if let likes = self.posts[index].likes {
                self.posts[index].likes = likes + 1
            } else {
                self.posts[index].likes = 1
            }
            self.posts[index].didLike = true
            try await likePostService.likePost(post)
        } catch {
            posts[index].didLike = false
            if posts[index].likes ?? 0 > 0 {
                posts[index].likes! -= 1
            }
        }
    }
    
    func unlike(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            if posts[index].likes ?? 0 > 0 {
                posts[index].likes! -= 1
            }
            self.posts[index].didLike = false
            try await likePostService.unlikePost(post)
        } catch {
            posts[index].didLike = true
            if let _ = post.likes {
                posts[index].likes! += 1
            }
        }
    }
    
    func checkIfUserLikedPost(_ post: Post) async  {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            self.posts[index].didLike = try await likePostService.checkIfUserLikedPost(post)
        } catch {
            print("DEBUG: Failed check if user liked the post with error \(error)")
        }
    }
    
    func save(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            self.posts[index].didSave = true
            try await savePostsService.savePost(post)
        } catch {
            self.posts[index].didSave = false
            print("DEBUG: Failed save post with error: \(error)")
        }
    }
    
    func unsave(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            self.posts[index].didSave = false
            try await savePostsService.unsavePost(post)
        } catch {
            self.posts[index].didSave = true
            print("DEBUG: Failed unsave post with error: \(error)")
        }
    }
    
    func checkIfUserSavedPost(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            self.posts[index].didSave = try await savePostsService.checkIfUserSavedPost(post)
        } catch {
            print("DEBUG: Failed check if user saved the post with error \(error)")
        }
    }
}
