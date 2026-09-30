//
//  IGNotificationsViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI

@Observable
class IGNotificationsViewModel {
    
    var notifications = [IGNotification]()
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        self.notifications = DeveloperPreview.shared.notifications
    }
}
