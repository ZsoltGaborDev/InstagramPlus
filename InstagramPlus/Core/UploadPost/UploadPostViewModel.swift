//
//  UploadPostViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 22/09/2026.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
@Observable
final class UploadPostViewModel {
    
    var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    var postImage: Image?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.postImage = Image(uiImage: uiImage)
    }
}
