//
//  LikesCache.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Foundation

class LikesCache: UserActivityCache {
    private var refreshInterval: TimeInterval = 60 * 60 * 24 //24 hours
    static let shared = LikesCache()
    
    private init() {
        super.init(refreshInterval: refreshInterval, cacheIdentifier: "user-likes")
    }
}
