//
//  PostGridViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 26/09/2026.
//

import Foundation
import SwiftUI
import Combine

@Observable
class PostGridViewModel: FeedViewModelProtocol {
    
    var posts = [Post]()
    var loadingState: ContentLoadingState = .loading
    private let service: PostGridServiceProtocol
    private(set) var userService: UserServiceProtocol
    private(set) var likePostService: LikePostServiceProtocol
    private(set) var savePostsService: SavedPostsServiceProtocol
    private(set) var notificationManager: IGNotificationsManager
                     
    
    init(service: PostGridServiceProtocol,
         likePostService: LikePostServiceProtocol,
         savePostsService: SavedPostsServiceProtocol,
         userService: UserServiceProtocol,
         notificationManager: IGNotificationsManager
    ) {
        self.service = service
        self.likePostService = likePostService
        self.savePostsService = savePostsService
        self.userService = userService
        self.notificationManager = notificationManager
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async  {
        do {
            let result = try await service.fetchPost()
            let completeResult = try await fetchPostUserData(posts: result)
            posts.append(contentsOf: completeResult)
            loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            print("DEBUG: Failed fetching posts with error: \(error) ")
            loadingState = .error
        }
    }
}
