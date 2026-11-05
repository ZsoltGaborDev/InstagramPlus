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
    
    private let service: UploadPostServiceProtocol
    
    init(service: UploadPostServiceProtocol) {
        self.service = service
    }
    
    var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    var postImage: Image?
    var loadingState: ContentLoadingState?
    private var uiImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String) async {
        guard let uiImage = uiImage else {return}
        loadingState = .loading
        do {
            try await service.uploadPost(caption: caption, image: uiImage)
            loadingState = .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to upload post with error: \(error)")
        }
    }
}
