//
//  EditProfileViewModel.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 25/09/2026.
//

import SwiftUI
import PhotosUI
import Firebase

@Observable
class EditProfileViewModel {
    var user: User
    var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    var profileImage: Image?
    var fullname: String = ""
    var bio: String = ""
    
    init(user: User) {
        self.user = user
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateUserdata() async throws {
        //update profile image if changed
        var data = [String: Any]()
        
        //update name if changed
        !fullname.isEmpty && user.fullname != fullname ? data["fullname"] = fullname : ()
        
        //update bio if changed
        !bio.isEmpty && user.bio != bio ? data["bio"] = bio : ()
        
        if !data.isEmpty {
            let userRef = Firestore.firestore().collection("users").document(user.id)
            try await userRef.updateData(data)
        }
    }
}
