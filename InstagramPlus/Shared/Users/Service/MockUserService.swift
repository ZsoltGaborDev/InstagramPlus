//
//  MockUserService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import Foundation

class MockUserService: UserServiceProtocol {
    func fetchCurrentUser() async throws -> User? {
        return nil
    }
}
