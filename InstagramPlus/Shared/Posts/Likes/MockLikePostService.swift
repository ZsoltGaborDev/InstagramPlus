//
//  MockLikePostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 16/10/2026.
//

import Foundation

class MockLikePostService: LikePostServiceProtocol {
    var didCallLikePost: Bool = false
    var didCallUnlikePost: Bool = false
    
    func likePost(_ post: Post) async throws {
        didCallLikePost = true
    }
    
    func unlikePost(_ post: Post) async throws {
        didCallUnlikePost = true
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
    

}
