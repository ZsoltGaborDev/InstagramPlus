//
//  UploadPostService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/11/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol UploadPostServiceProtocol {
    func uploadPost(caption: String, image: UIImage) async throws
}

struct UploadPostService: UploadPostServiceProtocol {
    
    private var uiImage: UIImage?
    
    func uploadPost(caption: String, image: UIImage) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postRef = FirebaseConstant
            .PostsCollection
            .document()
        guard let imageUrl = try? await ImageUploader.uploadPostImage(image) else { return }
        let post = Post(
            id: postRef.documentID,
            ownerUid: uid,
            caption: caption,
            likes: 0,
            imageUrl: imageUrl,
            timestamp: Date(),
        )
        let encodedPost = try Firestore.Encoder().encode(post)
        try await postRef.setData(encodedPost)
    }
}
