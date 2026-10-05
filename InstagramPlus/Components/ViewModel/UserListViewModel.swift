//
//  UserListViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation

@Observable
class UserListViewModel {
    var users = [User]()
    
    init() {}
    
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
    
    func fetchUsers(forConfig config: UserListConfig) async {
        do {
            self.users = try await UserService.fetchUsers(withConfig: config)
        } catch {
            print("DEBUG: Error fetching users: \(error.localizedDescription)")
        }
    }
}
