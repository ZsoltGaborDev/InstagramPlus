//
//  MockData.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import Foundation

struct MockData {
    static var image_url = "https://res.cloudinary.com/lkx9igck/image/upload/v1790347449/profile_images/g3ao8ytl6mgh3rpuvj1x.jpg"
    
    static var posts: [Post] = [
        .init(id: UUID().uuidString, ownerUid: users[1].id, caption: "Venom is hungry, time to eat.", likes: Int.random(in: 100...10_000), imageUrl: image_url, timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[0].id, caption: "Morning coffee and a fresh start.", likes: Int.random(in: 20...2_000), imageUrl: "instagramPlus1", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[2].id, caption: "Small moments, big memories.", likes: Int.random(in: 50...5_000), imageUrl: "instagramPlus12", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[3].id, caption: "Weekend mode activated.", likes: Int.random(in: 100...8_000), imageUrl: "instagramPlus7", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[1].id, caption: "Collecting sunsets, not things.", likes: Int.random(in: 500...15_000), imageUrl: "instagramPlus15", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[0].id, caption: "A little progress every day.", likes: Int.random(in: 10...1_000), imageUrl: "instagramPlus3", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[2].id, caption: "This view never gets old.", likes: Int.random(in: 200...10_000), imageUrl: "instagramPlus9", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[3].id, caption: "Keep it simple.", likes: Int.random(in: 20...2_500), imageUrl: "instagramPlus17", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[1].id, caption: "Made with love and good vibes.", likes: Int.random(in: 50...4_000), imageUrl: "instagramPlus6", timestamp: Date()),
        .init(id: UUID().uuidString, ownerUid: users[0].id, caption: "Just another beautiful day.", likes: Int.random(in: 100...7_000), imageUrl: "instagramPlus11", timestamp: Date())
    ]
    
    static var users: [User] = [
        .init(id: NSUUID().uuidString, username: "Batman", profileImageUrl: nil, fullname: "Bruce Wayne", bio: "Old Funny Man", email: "a@b.c", isPrivate: true),
        .init(id: NSUUID().uuidString, username: "LadyM", profileImageUrl: nil, fullname: "Madonna Mia", bio: "Old Funny Lady", email: "b@b.c", isPrivate: true),
        .init(id: NSUUID().uuidString, username: "DarkAngel", profileImageUrl: nil, fullname: "Doctor Strange", bio: "Old Black Man or Lady", email: "c@b.c", isPrivate: false),
        .init(id: NSUUID().uuidString, username: "venom", profileImageUrl: nil,fullname: "Marchiseppe Mariano" , bio: ".... run!!", email: "d@b.c", isPrivate: true),
        .init(id: NSUUID().uuidString, username: "fastandfurious", profileImageUrl: nil, bio: "running after nothing", email: "e@b.c", isPrivate: false),
        .init(id: NSUUID().uuidString, username: "asino", profileImageUrl: nil, fullname: "Materazzi Giuseppe", bio: "Old Shit Man", email: "f@b.c", isPrivate: false)
        
    ]
    
    static var comments: [Comment] = [
        .init(id: UUID().uuidString, commentOwnerUid: users[0].id, text: "This is amazing!", postId: posts[0].id, postOwnerUid: posts[0].ownerUid, timestamp: Date(), user: users[0]),
        .init(id: UUID().uuidString, commentOwnerUid: users[1].id, text: "Love the vibes here.", postId: posts[0].id, postOwnerUid: posts[0].ownerUid, timestamp: Date(), user: users[1]),
        .init(id: UUID().uuidString, commentOwnerUid: users[2].id, text: "Where was this taken?", postId: posts[1].id, postOwnerUid: posts[1].ownerUid, timestamp: Date(), user: users[2]),
        .init(id: UUID().uuidString, commentOwnerUid: users[3].id, text: "Absolutely stunning shot.", postId: posts[1].id, postOwnerUid: posts[1].ownerUid, timestamp: Date(), user: users[3]),
        .init(id: UUID().uuidString, commentOwnerUid: users[4].id, text: "Great composition!", postId: posts[2].id, postOwnerUid: posts[2].ownerUid, timestamp: Date(), user: users[4]),
        .init(id: UUID().uuidString, commentOwnerUid: users[5].id, text: "Haha, this made my day.", postId: posts[2].id, postOwnerUid: posts[2].ownerUid, timestamp: Date(), user: users[5]),
        .init(id: UUID().uuidString, commentOwnerUid: users[0].id, text: "That caption is on point.", postId: posts[3].id, postOwnerUid: posts[3].ownerUid, timestamp: Date(), user: users[0]),
        .init(id: UUID().uuidString, commentOwnerUid: users[1].id, text: "Need to visit this place.", postId: posts[3].id, postOwnerUid: posts[3].ownerUid, timestamp: Date(), user: users[1]),
        .init(id: UUID().uuidString, commentOwnerUid: users[2].id, text: "You never miss!", postId: posts[4].id, postOwnerUid: posts[4].ownerUid, timestamp: Date(), user: users[2]),
        .init(id: UUID().uuidString, commentOwnerUid: users[3].id, text: "The light is perfect.", postId: posts[4].id, postOwnerUid: posts[4].ownerUid, timestamp: Date(), user: users[3]),
        .init(id: UUID().uuidString, commentOwnerUid: users[4].id, text: "Tell me more about this.", postId: posts[5].id, postOwnerUid: posts[5].ownerUid, timestamp: Date(), user: users[4]),
        .init(id: UUID().uuidString, commentOwnerUid: users[5].id, text: "Big mood.", postId: posts[5].id, postOwnerUid: posts[5].ownerUid, timestamp: Date(), user: users[5]),
        .init(id: UUID().uuidString, commentOwnerUid: users[0].id, text: "Hope you had a great time.", postId: posts[6].id, postOwnerUid: posts[6].ownerUid, timestamp: Date(), user: users[0]),
        .init(id: UUID().uuidString, commentOwnerUid: users[1].id, text: "Can we get more like this?", postId: posts[6].id, postOwnerUid: posts[6].ownerUid, timestamp: Date(), user: users[1]),
        .init(id: UUID().uuidString, commentOwnerUid: users[2].id, text: "Just wow.", postId: posts[7].id, postOwnerUid: posts[7].ownerUid, timestamp: Date(), user: users[2]),
        .init(id: UUID().uuidString, commentOwnerUid: users[3].id, text: "Been waiting for this one.", postId: posts[7].id, postOwnerUid: posts[7].ownerUid, timestamp: Date(), user: users[3]),
        .init(id: UUID().uuidString, commentOwnerUid: users[4].id, text: "Could stare at this all day.", postId: posts[8].id, postOwnerUid: posts[8].ownerUid, timestamp: Date(), user: users[4]),
        .init(id: UUID().uuidString, commentOwnerUid: users[5].id, text: "What camera do you use?", postId: posts[8].id, postOwnerUid: posts[8].ownerUid, timestamp: Date(), user: users[5]),
        .init(id: UUID().uuidString, commentOwnerUid: users[0].id, text: "Pure art.", postId: posts[9].id, postOwnerUid: posts[9].ownerUid, timestamp: Date(), user: users[0]),
        .init(id: UUID().uuidString, commentOwnerUid: users[1].id, text: "Saving this for later.", postId: posts[9].id, postOwnerUid: posts[9].ownerUid, timestamp: Date(), user: users[1]),
        .init(id: UUID().uuidString, commentOwnerUid: users[2].id, text: "Keep them coming!", postId: posts[10].id, postOwnerUid: posts[10].ownerUid, timestamp: Date(), user: users[2]),
        .init(id: UUID().uuidString, commentOwnerUid: users[3].id, text: "This hits different.", postId: posts[10].id, postOwnerUid: posts[10].ownerUid, timestamp: Date(), user: users[3]),
        .init(id: UUID().uuidString, commentOwnerUid: users[4].id, text: "Dropping fire today.", postId: posts[11].id, postOwnerUid: posts[11].ownerUid, timestamp: Date(), user: users[4]),
        .init(id: UUID().uuidString, commentOwnerUid: users[5].id, text: "Instant favorite.", postId: posts[11].id, postOwnerUid: posts[11].ownerUid, timestamp: Date(), user: users[5]),
        .init(id: UUID().uuidString, commentOwnerUid: users[0].id, text: "This belongs in a frame.", postId: posts[12].id, postOwnerUid: posts[12].ownerUid, timestamp: Date(), user: users[0])
    ]
}
