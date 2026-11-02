//
//  UserService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserServiceProtocol {
    func fetchCurrentUser() async throws -> User?
    func fetchUser(withUid uid: String) async throws -> User
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws
}

class UserService: UserServiceProtocol {
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        try await FirebaseConstant
            .UsersCollection
            .document(currentUid)
            .updateData(["isPrivate": isPrivate])
    }
    
    func fetchCurrentUser() async throws -> User? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .getDocument(as: User.self)
    }
    
    func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .getDocument()
        return try snapshot.data(as: User.self)
    }
}

//MARK: - User Stats

extension UserService {
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingCount = FirebaseConstant
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments()
            .count
        
        async let followersCount = FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments()
            .count
        
        async let postCount = FirebaseConstant
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
            .count
        
        return try await UserStats(
            followingCount: followingCount,
            followersCount: followersCount,
            postsCount: postCount
        )
    }
}
