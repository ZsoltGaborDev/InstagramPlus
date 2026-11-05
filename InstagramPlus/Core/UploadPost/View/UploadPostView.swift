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
    @State var viewModel = UploadPostViewModel(service: UploadPostService())
    @Binding var tabIndex: Int
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .navigationTitle("New Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        clearPostData()
                        returnToFeed()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        uploadPost()
                    } label: {
                        ZStack {
                            if let loadingState = viewModel.loadingState, loadingState == .loading {
                                ProgressView()
                            } else {
                                Text("Upload")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension UploadPostView {
    func uploadPost() {
        Task {
            await viewModel.uploadPost(caption: caption)
            clearPostData()
            returnToFeed()
        }
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
