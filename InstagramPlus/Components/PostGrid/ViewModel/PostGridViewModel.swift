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
    private(set) var likePostService: LikePostServiceProtocol
    private(set) var savePostsService: SavedPostsServiceProtocol
    
    init(service: PostGridServiceProtocol,
         likePostService: LikePostServiceProtocol,
         savePostsService: SavedPostsServiceProtocol
    ) {
        self.service = service
        self.likePostService = likePostService
        self.savePostsService = savePostsService
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async  {
        do {
            let result = try await service.fetchPost()
            posts.append(contentsOf: result)
            loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            print("DEBUG: Failed fetching posts with error: \(error) ")
            loadingState = .error
        }
    }
}
