//
//  User.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

extension User {
    static var MOCK_USER: [User] = [
        .init(id: NSUUID().uuidString, username: "Batman", profileImageUrl: "instagramPlus17", fullname: "Bruce Wayne", bio: "Old Funny Man", email: "a@b.c"),
        .init(id: NSUUID().uuidString, username: "LadyM", profileImageUrl: "instagramPlus3", fullname: "Madonna Mia", bio: "Old Funny Lady", email: "b@b.c"),
        .init(id: NSUUID().uuidString, username: "DarkAngel", profileImageUrl: "instagramPlus4", fullname: "Doctor Strange", bio: "Old Black Man or Lady", email: "c@b.c"),
        .init(id: NSUUID().uuidString, username: "venom", profileImageUrl: "instagramPlus7",fullname: "Marchiseppe Mariano" , bio: ".... run!!", email: "d@b.c"),
        .init(id: NSUUID().uuidString, username: "fastandfurious", profileImageUrl: "instagramPlus12", bio: "running after nothing", email: "e@b.c"),
        .init(id: NSUUID().uuidString, username: "asino", profileImageUrl: "instagramPlus13", fullname: "Materazzi Giuseppe", bio: "Old Shit Man", email: "f@b.c")
        
    ]
}
