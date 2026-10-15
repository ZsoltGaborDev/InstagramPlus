//
//  SavedPostCache.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Foundation
import FirebaseAuth
import Firebase

class SavedPostCache {
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
    
    func set(_ savedPostIDs: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        cache.setObject(savedPostIDs as NSArray, forKey: uid as NSString)
        saveToDisk(savedPostIDs, for: uid)
    }
    
    func getValue(_ postId: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let postIDs = cache.object(forKey: uid as NSString) else { return false }
        return postIDs.contains(postId)
    }
    
    func update(_ postId: String, didSave: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var postIDs = cache.object(forKey: uid as NSString) as? [String] else { return }
        
        if didSave {
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
                let snapshot = try await FirebaseConstant.UserSavedPostCollection(uid: uid).getDocuments()
                let savedPostIDs = snapshot.documents.map { $0.documentID }
                set(savedPostIDs)
                saveLastFetched(for: uid, date: Date())
            }
        } else {
            loadCacheFromDisk(for: uid)
        }
    }
}

private extension SavedPostCache {
    func saveToDisk(_ item: [String], for uid: String) {
        do {
            let fileName = "saved-posts_\(uid).json"
            try DiskCache.save(item, to: fileName)
        } catch {
            print("Debug: Failed to save to disk: \(error.localizedDescription)")
        }
    }
    
    func loadCacheFromDisk(for uid: String) {
        do {
            let fileName = "saved-posts_\(uid).json"
            let items = try DiskCache.load(fileName, as: [String].self)
            set(items)
        } catch {
            print("Debug: Failed to load user saved posts from disk with error: \(error.localizedDescription)")
        }
    }
}

private extension SavedPostCache {
    func saveLastFetched(for uid: String, date: Date) {
        UserDefaults.standard.set(date, forKey: "lastFetched_\(uid)_saved-posts")
        lastFetched[uid] = date
    }
    
    func loadLastFetched(for uid: String) -> Date? {
        return UserDefaults.standard.object(forKey: "lastFetched_\(uid)_user-saved-posts") as? Date
    }
    
    var needsRefresh: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let lastFetched = lastFetched[uid] else { return true }
        return Date().timeIntervalSince(lastFetched) > refreshInterval
    }
}

