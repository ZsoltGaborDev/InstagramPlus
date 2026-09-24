//
//  Date.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import Foundation

extension Date {
    var instagramTimeString: String {
        let seconds = Int(Date().timeIntervalSince(self))
        
        switch seconds {
        case 0..<60:
            return "\(seconds)s ago"
        case 60..<3_600:
            return "\(seconds / 60)m ago"
        case 3_600..<86_400:
            return "\(seconds / 3_600)h ago"
        case 86_400..<604_800:
            return "\(seconds / 86_400)d ago"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }
}
