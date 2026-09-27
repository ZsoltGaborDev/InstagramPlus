//
//  Post.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import Foundation
import Firebase

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String
    var likes: Int?
    let imageUrl: String
    let timestamp: Timestamp

    var user: User?
    var didLike: Bool?

    enum CodingKeys: String, CodingKey {
        case id, ownerUid, caption, likes, imageUrl, timestamp
    }
}

extension Post {
    
    static var MOCK_IMAGE_URL = "https://res.cloudinary.com/lkx9igck/image/upload/v1790347449/profile_images/g3ao8ytl6mgh3rpuvj1x.jpg"
    
    static var MOCK_POSTS: [Post] = [
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Venom is hungry, time to eat.", likes: Int.random(in: 100...10_000), imageUrl: MOCK_IMAGE_URL, timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Morning coffee and a fresh start.", likes: Int.random(in: 20...2_000), imageUrl: "instagramPlus1", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Small moments, big memories.", likes: Int.random(in: 50...5_000), imageUrl: "instagramPlus12", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Weekend mode activated.", likes: Int.random(in: 100...8_000), imageUrl: "instagramPlus7", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Collecting sunsets, not things.", likes: Int.random(in: 500...15_000), imageUrl: "instagramPlus15", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "A little progress every day.", likes: Int.random(in: 10...1_000), imageUrl: "instagramPlus3", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "This view never gets old.", likes: Int.random(in: 200...10_000), imageUrl: "instagramPlus9", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Keep it simple.", likes: Int.random(in: 20...2_500), imageUrl: "instagramPlus17", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Made with love and good vibes.", likes: Int.random(in: 50...4_000), imageUrl: "instagramPlus6", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Just another beautiful day.", likes: Int.random(in: 100...7_000), imageUrl: "instagramPlus11", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Taking the scenic route.", likes: Int.random(in: 200...12_000), imageUrl: "instagramPlus2", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Good things take time.", likes: Int.random(in: 10...1_500), imageUrl: "instagramPlus14", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "New day, new energy.", likes: Int.random(in: 50...3_000), imageUrl: "instagramPlus8", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Living for the little details.", likes: Int.random(in: 100...6_000), imageUrl: "instagramPlus5", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Out here making memories.", likes: Int.random(in: 300...9_000), imageUrl: "instagramPlus16", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Today feels like a good day.", likes: Int.random(in: 50...4_000), imageUrl: "instagramPlus10", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Stay curious.", likes: Int.random(in: 10...2_000), imageUrl: "instagramPlus13", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "One step closer to the goal.", likes: Int.random(in: 100...5_000), imageUrl: "instagramPlus4", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Creating my own kind of magic.", likes: Int.random(in: 500...20_000), imageUrl: "instagramPlus7", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Nothing but good energy.", likes: Int.random(in: 20...3_000), imageUrl: "instagramPlus1", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "A pause worth taking.", likes: Int.random(in: 100...6_000), imageUrl: "instagramPlus12", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Find beauty in the ordinary.", likes: Int.random(in: 50...4_000), imageUrl: "instagramPlus3", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Adventure is always a good idea.", likes: Int.random(in: 300...15_000), imageUrl: "instagramPlus15", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "One more for the camera roll.", likes: Int.random(in: 10...2_000), imageUrl: "instagramPlus9", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Feeling grateful today.", likes: Int.random(in: 100...7_000), imageUrl: "instagramPlus17", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Chasing light.", likes: Int.random(in: 50...5_000), imageUrl: "instagramPlus6", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Life lately.", likes: Int.random(in: 20...2_000), imageUrl: "instagramPlus11", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Keep going, you are doing great.", likes: Int.random(in: 200...8_000), imageUrl: "instagramPlus2", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "The best is yet to come.", likes: Int.random(in: 100...10_000), imageUrl: "instagramPlus14", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "A moment of calm.", likes: Int.random(in: 10...1_500), imageUrl: "instagramPlus8", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Here for a good time.", likes: Int.random(in: 50...5_000), imageUrl: "instagramPlus5", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Fresh air, clear mind.", likes: Int.random(in: 100...8_000), imageUrl: "instagramPlus16", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Trust the process.", likes: Int.random(in: 20...3_000), imageUrl: "instagramPlus10", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Simple pleasures.", likes: Int.random(in: 10...2_000), imageUrl: "instagramPlus13", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Making space for joy.", likes: Int.random(in: 200...10_000), imageUrl: "instagramPlus4", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Just vibes.", likes: Int.random(in: 50...4_000), imageUrl: "instagramPlus7", timestamp: Timestamp(), user: User.MOCK_USER[3]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "A little escape from routine.", likes: Int.random(in: 100...6_000), imageUrl: "instagramPlus1", timestamp: Timestamp(), user: User.MOCK_USER[1]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Building something exciting.", likes: Int.random(in: 500...18_000), imageUrl: "instagramPlus12", timestamp: Timestamp(), user: User.MOCK_USER[0]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Smile, it looks good on you.", likes: Int.random(in: 50...5_000), imageUrl: "instagramPlus15", timestamp: Timestamp(), user: User.MOCK_USER[2]),
        .init(id: UUID().uuidString, ownerUid: UUID().uuidString, caption: "Ending the day on a high note.", likes: Int.random(in: 100...9_000), imageUrl: "instagramPlus9", timestamp: Timestamp(), user: User.MOCK_USER[3])
    ]
}
