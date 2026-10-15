//
//  UserActivityCache.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 15/10/2026.
//

import Firebase
import FirebaseAuth

class UserActivityCache {
    private var cache = NSCache<NSString, NSArray>()
    private var lastFetched = [String: Date]()
    
    private var refreshInterval: TimeInterval
    private var cacheIdentifier: String // user-likes, saved-posts
    
    init(refreshInterval: TimeInterval, cacheIdentifier: String) {
        self.refreshInterval = refreshInterval
        self.cacheIdentifier = cacheIdentifier
        
        initializeCache()
    }
    
    func initializeCache() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let lastFetchedTime = loadLastFetched(for: uid) {
            lastFetched[uid] = lastFetchedTime
        }
        loadCacheData()
    }
    
    func set(_ items: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        cache.setObject(items as NSArray, forKey: uid as NSString)
        saveToDisk(items, for: uid)
    }
    
    func update(_ item: String, didAdd: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var items = cache.object(forKey: uid as NSString) as? [String] else { return }
        
        if didAdd {
            items.append(item)
        } else {
            items.removeAll(where: { $0 == item })
        }
        set(items)
    }
    
    func contains(_ item: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let items = cache.object(forKey: uid as NSString) else { return false }
        return items.contains(item)
    }
}

private extension UserActivityCache {
    func loadCacheData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if needsRefresh {
            Task {
                let ref = FirebaseConstant.UsersCollection.document(uid).collection(cacheIdentifier)
                let snapshot = try await ref.getDocuments()
                let items = snapshot.documents.map { $0.documentID }
                set(items)
                saveLastFetched(for: uid, date: Date())
            }
        } else {
            loadCacheFromDisk(for: uid)
        }
    }
}

private extension UserActivityCache {
    func saveToDisk(_ item: [String], for uid: String) {
        do {
            let fileName = fileName(for: uid)
            try DiskCache.save(item, to: fileName)
        } catch {
            print("Debug: Failed to save to disk: \(error.localizedDescription)")
        }
    }
    
    func loadCacheFromDisk(for uid: String) {
        do {
            let fileName = fileName(for: uid)
            let items = try DiskCache.load(fileName, as: [String].self)
            set(items)
        } catch {
            print("Debug: Failed to load user saved posts from disk with error: \(error.localizedDescription)")
        }
    }
    
    func fileName(for uid: String) -> String {
        return "\(cacheIdentifier)_\(uid).json"
    }
}

private extension UserActivityCache {
    func saveLastFetched(for uid: String, date: Date) {
        UserDefaults.standard.set(date, forKey: "lastFetched_\(uid)_\(cacheIdentifier)")
        lastFetched[uid] = date
    }
    
    func loadLastFetched(for uid: String) -> Date? {
        return UserDefaults.standard.object(forKey: "lastFetched_\(uid)_\(cacheIdentifier)") as? Date
    }
    
    var needsRefresh: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let lastFetched = lastFetched[uid] else { return true }
        return Date().timeIntervalSince(lastFetched) > refreshInterval
    }
}
