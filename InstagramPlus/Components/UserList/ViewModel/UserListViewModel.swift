//
//  UserListViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Foundation

@MainActor
@Observable
class UserListViewModel {
    var users = [User]()
    var loadingState: ContentLoadingState = .loading
    
    private let service: UserListServiceProtocol
    private var isFetching = false
    
    init(service: UserListServiceProtocol) {
        self.service = service
    }
    
    func fetchUsers(forConfig config: UserListConfiguration) async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }

        do {
            let result = try await service.fetchUsers(withConfig: config)
            var knownIDs = Set(users.map(\.id))
            self.users.append(contentsOf: result.filter { knownIDs.insert($0.id).inserted })
            self.loadingState = users.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
            print("DEBUG: Error fetching users: \(error.localizedDescription)")
        }
    }
}
