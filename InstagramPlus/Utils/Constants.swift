//
//  Constants.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Firebase

struct FirebaseConstant {
    
    static let Root = Firestore.firestore()
    
    static let UsersCollection = Root.collection("users")
    
    static let PostsCollection = Root.collection("posts")
    
    static let FollowingCollection = Root.collection("following")
    static let FollowersCollection = Root.collection("followers")
    
    static let IGNotificationCollection = Root.collection("notifications")
    
    static func UserNotificationCollection(uid: String) -> CollectionReference {
        return IGNotificationCollection.document(uid).collection("user-notifications")
    }
    
    static func UserSavedPostCollection(uid: String) -> CollectionReference {
        return UsersCollection.document(uid).collection("saved-posts")
    }
    
    static func UserFeedCollection(uid: String) -> CollectionReference {
        return UsersCollection.document(uid).collection("user-feed")
    }
    
    static let MessageCollection = Root.collection("messages")
}
