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
}

class IGNotificationFetchingService: IGNotificationFetchingServiceProtocol {
    
    func fetchNotifications() async throws -> [IGNotification] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        return try await FirebaseConstant
            .UserNotificationCollection(uid: currentUid)
            .order(by: "timestamp", descending: true)
            .getDocuments(as: IGNotification.self)
    }
}
