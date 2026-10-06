//
//  MockUserService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import Foundation

class MockUserService: UserServiceProtocol {
    func fetchUser(withUid uid: String) async throws -> User {
        return User(
            id: uid,
            username: "test",
            profileImageUrl: "https://res.cloudinary.com/lkx9igck/image/upload/v1791304116/Screenshot_2026-10-06_at_18.27.58.png", 
            fullname: "Rambo John",
            email: "test@example.com"
        )
    }
    
    func fetchCurrentUser() async throws -> User? {
        return User(
            id: "123",
            username: "test",
            profileImageUrl: "https://res.cloudinary.com/lkx9igck/image/upload/v1791304116/Screenshot_2026-10-06_at_18.27.58.png",
            fullname: "Rambo John",
            email: "test@example.com"
        )
    }
}
