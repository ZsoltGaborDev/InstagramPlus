//
//  IGNotificationFetchingService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol IGNotificationFetchingServiceProtocol {
    func fetchNotifications() async throws -> [IGNotification]
    func refreshNotifications() async throws -> [IGNotification]
}

class IGNotificationFetchingService: IGNotificationFetchingServiceProtocol {
    private let fetchLimit = 20
    private var lastDoc: QueryDocumentSnapshot?
    private var shouldLoadMoreData = true
    
    func fetchNotifications() async throws -> [IGNotification] {
        guard let currentUid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstant
            .UserNotificationCollection(uid: currentUid)
            .order(by: "timestamp", descending: true)
            .limit(to: fetchLimit)
        
        var snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
            if let last = snapshot.documents.last { self.lastDoc = last}
        } else {
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        shouldLoadMoreData = snapshot.documents.count == fetchLimit
        return snapshot.documents.compactMap { try? $0.data(as: IGNotification.self) }
    }
    
    func refreshNotifications() async throws -> [IGNotification] {
        lastDoc = nil
        shouldLoadMoreData = true
        return try await fetchNotifications()
    }
}
