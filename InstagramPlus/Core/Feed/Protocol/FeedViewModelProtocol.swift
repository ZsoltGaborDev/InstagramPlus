//
//  FeedViewModelProtocol.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 22/10/2026.
//

import Foundation

@MainActor
protocol FeedViewModelProtocol: AnyObject, Observable {
    var posts: [Post] { get set }
    var likePostService: LikePostServiceProtocol { get }
    var savePostsService: SavedPostsServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    
    func like(_ post: Post) async
    func unlike(_ post: Post) async
    func didLike(_ post: Post) async
    
    func save(_ post: Post) async
    func unsave(_ post: Post) async
    func didSave(_ post: Post) async
    
}

extension FeedViewModelProtocol {
    
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
    
    func didLike(_ post: Post) async {
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
    
    func didSave(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {return}
        
        do {
            self.posts[index].didSave = try await savePostsService.checkIfUserSavedPost(post)
        } catch {
            print("DEBUG: Failed check if user saved the post with error \(error)")
        }
    }
}

extension FeedViewModelProtocol {
    func fetchPostUserData(posts: [Post]) async throws -> [Post] {
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
