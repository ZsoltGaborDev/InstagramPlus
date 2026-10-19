//
//  SettingsActivitySectionModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 18/10/2026.
//

import Foundation

enum SettingsActivitySectionModel: Int, CaseIterable {
    case savedPosts
    case likedPosts
}

extension SettingsActivitySectionModel: Identifiable, Hashable {
    var id: Int { return self.rawValue }
}

extension SettingsActivitySectionModel: CustomStringConvertible {
    var description: String {
        switch self {
        case .savedPosts:
            return "Saved posts"
        case .likedPosts:
            return "Liked posts"
        }
    }
}
