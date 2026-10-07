//
//  FeedRouter.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation
import SwiftUI

enum FeedRouter: Hashable {
    case inbox
    case profile(User)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case.inbox:
            Text("Inbox view")
        case.profile(let user):
            ProfileView(user: user)
        }
    }
}
