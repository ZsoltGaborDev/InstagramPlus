//
//  SearchViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation

@Observable
class SearchViewModel {
    var users = [User]()
    
    init() {
        Task { try await fetchAllUsers()}
    }
    
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
