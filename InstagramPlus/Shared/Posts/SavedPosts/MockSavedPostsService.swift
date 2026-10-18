//
//  MockSavedPostsService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 16/10/2026.
//

import Foundation

class MockSavedPostsService: SavedPostsServiceProtocol {
    var savePostDidCalled = false
    var unsavePostDidCalled = false
    
    func savePost(_ post: Post) async throws {
        savePostDidCalled = true
    }
    
    func unsavePost(_ post: Post) async throws {
        unsavePostDidCalled = true
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
}
