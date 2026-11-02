//
//  FollowRequestViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/10/2026.
//

import Foundation

@Observable
class FollowRequestViewModel {
    var requests = [FollowRequest]()
    var loadingState: ContentLoadingState = .loading
    
    private let followRequestService: FollowRequestService
    private let userService: UserServiceProtocol
    
    init(followRequestService: FollowRequestService, userService: UserServiceProtocol) {
        self.followRequestService = followRequestService
        self.userService = userService
    }
    
    func fetchRequest() async {
        do {
            let result = try await followRequestService.fetchFollowRequest()
            self.requests = try await fetchUserDataForRequests(result)
            self.loadingState = requests.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
        }
    }
    
    func accept(_ request: FollowRequest) async {
        guard let index = removeRequestOptimistically(request) else { return }
        do {
            try await followRequestService.accept(request)
        } catch {
            requests.insert(contentsOf: requests, at: index)
            print("DEBUG: Failed to accept follow request with error : \(error)")
        }
    }
    
    func reject(_ request: FollowRequest) async {
        guard let index = removeRequestOptimistically(request) else { return }
        do {
            try await followRequestService.reject(request)
        } catch {
            requests.insert(request, at: index)
            print("DEBUG: Failed to reject follow request with error : \(error)")
        }
    }
    
    private func removeRequestOptimistically(_ request: FollowRequest) -> Int? {
        guard let index = requests.firstIndex(where: { $0.id == request.id}) else { return nil }
        requests.remove(at: index)
        
        if requests.isEmpty {
            loadingState = .empty
        }
        
        return index
    }
    
    private func fetchUserDataForRequests(_ requests: [FollowRequest]) async throws -> [FollowRequest] {
        var result = requests
        
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            for (index, request) in requests.enumerated() {
                guard let self = self else {return}
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: request.fromUserId)
                    return (index, user)
                }
            }
            
            for try await (index, user) in group {
                result[index].user = user
            }
        }
        return result
    }
}
