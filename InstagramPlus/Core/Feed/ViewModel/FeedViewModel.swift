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
    private let userService: UserService
    
    init(feedService: FeedServiceProtocol, userService: UserService) {
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
