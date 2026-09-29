//
//  UserService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class UserService {
    
    var currentUser: User?
    static let shared = UserService()
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    func fetchCurrentuser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.currentUser = try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .getDocument(as: User.self)
    }
}

// MARK: - Following
extension UserService {
    static func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        async let _ = FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:])
        
        async let _ = FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .setData([:])
    }
    
    static func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete()
        
        async let _ = FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .delete()
    }
    
    static func checkIfUserIsFollowed(uid: String) async throws -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return try await FirebaseConstant
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .getDocument()
            .exists
    }
}
