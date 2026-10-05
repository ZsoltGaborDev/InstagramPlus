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
}

class UserService: UserServiceProtocol {
    
    var currentUser: User?
    
    func fetchCurrentUser() async throws -> User? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return try await FirebaseConstant
            .UsersCollection
            .document(uid)
            .getDocument(as: User.self)
    }
    
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
    
    static func fetchUsers(withConfig config: UserListConfig) async throws -> [User] {
        switch config {
            
        case .followers(uid: let uid):
            return try await fetchFollowers(uid: uid)
        case .following(uid: let uid):
            return try await fetchFollowing(uid: uid)
        case .likes(postId: let postId):
            return try await fetchPostLikesUsers(postId: postId)
        case .explore:
            return try await fetchAllUsers()
        }
    }
    
    private static func fetchFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments() //this gives back a list of ids
        
        return try await fetchUsers(snapshot)
        
    }
    
    private static func fetchFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments() //this gives back a list of ids
        
        return try await fetchUsers(snapshot)
    }
    
    private static func fetchPostLikesUsers(postId: String) async throws -> [User] {
        return []
    }
    
    private static func fetchUsers(_ snapshot: QuerySnapshot) async throws -> [User] {
        var users = [User]()
        
        for doc in snapshot.documents {
            users.append(try await fetchUser(withUid: doc.documentID))
        }
        return users
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
