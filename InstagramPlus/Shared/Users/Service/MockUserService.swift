//
//  MockUserService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import Foundation

class MockUserService: UserServiceProtocol {
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws {
        MockData.users[0].isPrivate.toggle()
    }
    
    func fetchUser(withUid uid: String) async throws -> User {
        return User(
            id: uid,
            username: "test",
            profileImageUrl: "https://res.cloudinary.com/lkx9igck/image/upload/v1791304116/Screenshot_2026-10-06_at_18.27.58.png", 
            fullname: "Rambo John",
            email: "test@example.com",
            isPrivate: false
        )
    }
    
    func fetchCurrentUser() async throws -> User? {
        return User(
            id: "123",
            username: "test",
            profileImageUrl: "https://res.cloudinary.com/lkx9igck/image/upload/v1791304116/Screenshot_2026-10-06_at_18.27.58.png",
            fullname: "Rambo John",
            email: "test@example.com",
            isPrivate: false
        )
    }
}
