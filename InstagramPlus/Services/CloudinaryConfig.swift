//
//  CloudinaryConfig.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 25/09/2026.
//

import Foundation

enum CloudinaryConfig {

    static let cloudName: String = value(for: "CLOUDINARY_CLOUD_NAME")
    static let uploadPreset: String = value(for: "CLOUDINARY_UPLOAD_PRESET")

    private static func value(for key: String) -> String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let value = plist[key] as? String,
            !value.isEmpty,
            !value.hasPrefix("REPLACE_WITH_")
        else {
            fatalError("Missing \(key) in Secrets.plist. Copy Secrets.example.plist to Secrets.plist and fill in your Cloudinary values.")
        }
        return value
    }
}
