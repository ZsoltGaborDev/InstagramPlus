//
//  UploadPostView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI
import PhotosUI

struct UploadPostView: View {
    
    @State private var caption = ""
    @State private var imagePicketIsPresened = false
    @State private var imageItem: PhotosPickerItem?
    @State var viewModel = UploadPostViewModel()
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
            //action bar tool
            HStack {
                Button {
                    clearPostData()
                    returnToFeed()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                
                Text("New Post")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    Task {
                        try await viewModel.uploadPost(caption: caption)
                        clearPostData()
                        returnToFeed()
                    }
                } label: {
                    Text("Upload")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            //post image and caption
            HStack {
                if let image = viewModel.postImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                }
                
                TextField("Enter your caption...", text: $caption, axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear() {
            self.imagePicketIsPresened.toggle()
        }
        .photosPicker(isPresented: $imagePicketIsPresened, selection: $viewModel.selectedImage)
        
    }
    
    func clearPostData(){
        caption = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
    }
    
    func returnToFeed() {
        tabIndex = 0
    }
}

#Preview {
    UploadPostView(tabIndex: .constant(0))
}
