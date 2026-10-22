//
//  SavedPostCache.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Foundation

class SavedPostsCache: UserActivityCache {
    private var refreshInterval: TimeInterval = 60 * 60 * 24 //24 hours
    static let shared = SavedPostsCache()
    
    private init() {
        super.init(refreshInterval: refreshInterval, cacheIdentifier: "saved-posts")
    }
}

