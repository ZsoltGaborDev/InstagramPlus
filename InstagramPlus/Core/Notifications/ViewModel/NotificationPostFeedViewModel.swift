//
//  NotificationPostFeedViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/11/2026.
//

import Foundation

@Observable
class NotificationPostFeedViewModel: FeedViewModelProtocol {
    var posts = [Post]()
    
    let likePostService: LikePostServiceProtocol
    let savePostsService: SavedPostsServiceProtocol
    let userService: UserServiceProtocol
    let notificationManager: IGNotificationsManager
    
    init(
        likePostService: LikePostServiceProtocol = LikePostService(),
        savePostsService: SavedPostsServiceProtocol = SavedPostsService(),
        userService: UserServiceProtocol = UserService(),
        notificationManager: IGNotificationsManager = IGNotificationsManager(service: IGNotificationManagementService())
    ) {
        self.likePostService = likePostService
        self.savePostsService = savePostsService
        self.userService = userService
        self.notificationManager = notificationManager
    }
    
    func configurePostUserData() async {
        do {
            let result = try await fetchPostUserData(posts: posts)
            posts = result
        } catch {
            print("DEBUG: Failed to fetch post user data with error: \(error)")
        }
    }
}
