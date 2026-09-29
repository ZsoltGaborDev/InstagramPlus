//
//  DeveloperPrevoewMockData.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import Firebase
import SwiftUI


let dev = DeveloperPreview.shared

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let comment = Comment(ownerUid: "123", text: "Test comment", postId: "321", postOwnerUid: "123456789", timestamp: Timestamp())
}
