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
class PostGridViewModel {
    
    private let user: User
    var posts = [Post]()
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserPosts() }
    }
    
    func fetchUserPosts() async throws {
        self.posts = try await PostService.fetchProfilePosts(uid: user.id)
        for i in 0..<self.posts.count {
            posts[i].user = self.user
        }
    }
}
