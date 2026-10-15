//
//  SavedPostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Firebase
import FirebaseAuth

protocol SavedPostServiceProtocol {
    func savePost(_ post: Post) async throws
    func unsavePost(_ post: Post) async throws
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool
}

class SavedPostService: SavedPostServiceProtocol {
    private let cache = SavedPostCache()
    
    func savePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstant.UserSavedPostCollection(uid: uid).document(post.id).setData([:])
        cache.update(post.id, didSave: true)
    }
    
    func unsavePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstant.UserSavedPostCollection(uid: uid).document(post.id).delete()
        cache.update(post.id, didSave: false)
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return cache.getValue(post.id)
    }
}
