//
//  LikesCache.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Foundation
import FirebaseAuth
import Firebase

class LikesCache {
    private var cache = NSCache<NSString, NSArray>()
    private var refreshInterval: TimeInterval = 60 * 60 * 24 //24 hours
    private var lastFetched = [String: Date]()
    
    init() {
        self.initializeCache()
    }
    
    func initializeCache() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let lastFetchedTime = loadLastFetched(for: uid) {
            lastFetched[uid] = lastFetchedTime
        }
        loadCacheData()
    }
    
    func set(_ likedPostIDs: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        cache.setObject(likedPostIDs as NSArray, forKey: uid as NSString)
        saveToDisk(likedPostIDs, for: uid)
    }
    
    func getValue(_ postId: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let postIDs = cache.object(forKey: uid as NSString) else { return false }
        return postIDs.contains(postId)
    }
    
    func update(_ postId: String, didLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var postIDs = cache.object(forKey: uid as NSString) as? [String] else { return }
        
        if didLike {
            postIDs.append(postId)
        } else {
            postIDs.removeAll(where: { $0 == postId })
        }
        set(postIDs)
    }
    
    func loadCacheData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if needsRefresh {
            Task {
                let snapshot = try await FirebaseConstant.UserLikesCollection(uid: uid).getDocuments()
                let likedPostIDs = snapshot.documents.map { $0.documentID }
                set(likedPostIDs)
                saveLastFetched(for: uid, date: Date())
            }
        } else {
            loadCacheFromDisk(for: uid)
        }
    }
}

private extension LikesCache {
    func saveToDisk(_ item: [String], for uid: String) {
        do {
            let fileName = "user-likes_\(uid).json"
            try DiskCache.save(item, to: fileName)
        } catch {
            print("Debug: Failed to save to disk: \(error.localizedDescription)")
        }
    }
    
    func loadCacheFromDisk(for uid: String) {
        do {
            let fileName = "user-likes_\(uid).json"
            let items = try DiskCache.load(fileName, as: [String].self)
            set(items)
        } catch {
            print("Debug: Failed to load user likes from disk with error: \(error.localizedDescription)")
        }
    }
}

private extension LikesCache {
    func saveLastFetched(for uid: String, date: Date) {
        UserDefaults.standard.set(date, forKey: "lastFetched_\(uid)_user-likes")
        lastFetched[uid] = date
    }
    
    func loadLastFetched(for uid: String) -> Date? {
        return UserDefaults.standard.object(forKey: "lastFetched_\(uid)_user-likes") as? Date
    }
    
    var needsRefresh: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let lastFetched = lastFetched[uid] else { return true }
        return Date().timeIntervalSince(lastFetched) > refreshInterval
    }
}
