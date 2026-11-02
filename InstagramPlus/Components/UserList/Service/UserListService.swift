//
//  UserListService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 02/11/2026.
//

import Foundation
import FirebaseFirestore

protocol UserListServiceProtocol {
    func fetchUsers(withConfig config: UserListConfiguration) async throws -> [User]
}

class UserListService: UserListServiceProtocol {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fetchUsers(withConfig config: UserListConfiguration) async throws -> [User] {
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
}

private extension UserListService {
    func fetchAllUsers() async throws -> [User] {
        return try await FirebaseConstant
            .UsersCollection
            .getDocuments(as: User.self)
    }
    
    func fetchFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments() //this gives back a list of ids
        
        return try await fetchUsers(snapshot)
        
    }
    
    func fetchFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments() //this gives back a list of ids
        
        return try await fetchUsers(snapshot)
    }
    
    func fetchPostLikesUsers(postId: String) async throws -> [User] {
        let snapshot = try await FirebaseConstant
            .PostLikesCollection(postId: postId)
            .getDocuments()
        return try await fetchUsers(snapshot)
    }
    
    func fetchUsers(_ snapshot: QuerySnapshot) async throws -> [User] {
        var users = [User]()

        for doc in snapshot.documents {
            users.append(try await userService.fetchUser(withUid: doc.documentID))
        }
        return users
    }
}
