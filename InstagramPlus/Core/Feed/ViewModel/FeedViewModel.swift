//
//  FeedViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 26/09/2026.
//

import Foundation
import SwiftUI

@Observable
class FeedViewModel: FeedViewModelProtocol {

    var posts = [Post]()
    var loadingState: ContentLoadingState = .loading
    
    private let feedService: FeedServiceProtocol
    private(set) var userService: UserServiceProtocol
    private(set) var likePostService: LikePostServiceProtocol
    private(set) var savePostsService: SavedPostsServiceProtocol
    
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
}
