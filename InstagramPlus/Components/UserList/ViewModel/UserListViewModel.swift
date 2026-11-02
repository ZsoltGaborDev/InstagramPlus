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
    
    private let service: UserListServiceProtocol
    
    init(service: UserListServiceProtocol) {
        self.service = service
    }
    
    func fetchUsers(forConfig config: UserListConfiguration) async {
        do {
            self.users = try await service.fetchUsers(withConfig: config)
        } catch {
            print("DEBUG: Error fetching users: \(error.localizedDescription)")
        }
    }
}
