//
//  UserListService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 02/11/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserListServiceProtocol {
    func fetchUsers(withConfig config: UserListConfiguration) async throws -> [User]
}

class UserListService: UserListServiceProtocol {
    private let userService: UserServiceProtocol
    
    private var lastDoc: QueryDocumentSnapshot?
    private let fetchLimit = 20
    private var shouldLoadMoreData = true
    
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
        guard shouldLoadMoreData else { return [] }
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot: QuerySnapshot
        let query = FirebaseConstant.UsersCollection.limit(to: fetchLimit)
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
            if let last = snapshot.documents.last { self.lastDoc = last }
        } else {
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        shouldLoadMoreData = snapshot.documents.count == fetchLimit
        
        return snapshot.documents
            .compactMap { try? $0.data(as: User.self) }
            .filter { $0.id != currentUid }
    }
    
    func fetchFollowers(uid: String) async throws -> [User] {
        let query = FirebaseConstant
            .UserFollowerCollection(uid: uid)
            .limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
        
    }
    
    func fetchFollowing(uid: String) async throws -> [User] {
        let query = FirebaseConstant
            .UserFollowingCollection(uid: uid)
            .limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
    }
    
    func fetchPostLikesUsers(postId: String) async throws -> [User] {
        let query = FirebaseConstant
            .PostLikesCollection(postId: postId)
            .limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
    }
    
    func fetchUsers(withQuery query: Query) async throws -> [User] {
        guard let snapshots = try await paginatedSnapshot(withQuery: query) else { return [] }
        var users = [User]()
        
        for doc in snapshots.documents {
            users.append(try await userService.fetchUser(withUid: doc.documentID))
        }
        return users
    }
    
    // returns paginated list of user ids
    func paginatedSnapshot(withQuery query: Query) async throws -> QuerySnapshot? {
        guard shouldLoadMoreData else { return nil }
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
            if let last = snapshot.documents.last { self.lastDoc = last }
        } else {
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        
        shouldLoadMoreData = snapshot.documents.count == fetchLimit
        return snapshot
    }
}

