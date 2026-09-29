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

//MARK: - User Stats

extension UserService {
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingSnapshot = try await FirebaseConstant
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments()
        let followingCount = try await followingSnapshot.count
        
        async let followersSnapshot = try await FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments()
        let followersCount = try await followersSnapshot.count
        
        async let postSnapshot = try await FirebaseConstant
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        let postCount = try await postSnapshot.count
        
        return UserStats(
            followingCount: followingCount,
            followersCount: followersCount,
            postsCount: postCount
        )
    }
}
