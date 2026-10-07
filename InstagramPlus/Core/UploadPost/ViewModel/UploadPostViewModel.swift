//
//  UploadPostViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 22/09/2026.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

@MainActor
@Observable
final class UploadPostViewModel {
    
    var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    var postImage: Image?
    private var uiImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uiImage = self.uiImage else { return }
        
        let postRef = FirebaseConstant
            .PostsCollection
            .document()
        guard let imageUrl = try? await ImageUploader.uploadPostImage(uiImage) else { return }
        let post = Post(
            id: postRef.documentID,
            ownerUid: uid,
            caption: caption,
            imageUrl: imageUrl,
            timestamp: Date()
        )
        let encodedPost = try Firestore.Encoder().encode(post)
        try await postRef.setData(encodedPost)
    }
}
