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
    var loadingState: ContentLoadingState = .loading
    
    private let service: UserListServiceProtocol
    
    init(service: UserListServiceProtocol) {
        self.service = service
    }
    
    func fetchUsers(forConfig config: UserListConfiguration) async {
        do {
            self.users = try await service.fetchUsers(withConfig: config)
            self.loadingState = users.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
            print("DEBUG: Error fetching users: \(error.localizedDescription)")
        }
    }
}
