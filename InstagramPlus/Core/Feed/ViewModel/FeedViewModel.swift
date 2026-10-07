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
    
    init() {
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async {
        do {
            self.posts = try await PostService.fetchFeedPosts()
            self.loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
        }
    }
}
