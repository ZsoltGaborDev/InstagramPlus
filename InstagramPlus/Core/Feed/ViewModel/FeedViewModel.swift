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
    
    init() {
        Task { try await fetchPosts() }
    }
    
    func fetchPosts() async throws {
        self.posts = try await PostService.fetchFeedPosts()
    }
}
