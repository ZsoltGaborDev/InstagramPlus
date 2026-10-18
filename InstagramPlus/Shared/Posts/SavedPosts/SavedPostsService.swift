//
//  SavedPostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Firebase
import FirebaseAuth

protocol SavedPostsServiceProtocol {
    func savePost(_ post: Post) async throws
    func unsavePost(_ post: Post) async throws
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool
}

class SavedPostsService: SavedPostsServiceProtocol {
    private let cache = SavedPostsCache()
    
    func savePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstant.UserSavedPostCollection(uid: uid).document(post.id).setData([:])
        cache.update(post.id, didAdd: true)
    }
    
    func unsavePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstant.UserSavedPostCollection(uid: uid).document(post.id).delete()
        cache.update(post.id, didAdd: false)
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return cache.contains(post.id)
    }
}
