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
    var posts = [Post]()
    
    private let service: PostGridServiceProtocol
    
    init(service: PostGridServiceProtocol) {
        self.service = service
        Task { await fetchPosts() }
    }
    
    func fetchPosts() async  {
        do {
            self.posts = try await service.fetchPost()
        } catch {
            print("DEBUG: Failed fetching posts with error: \(error) ")
        }
    }
}
