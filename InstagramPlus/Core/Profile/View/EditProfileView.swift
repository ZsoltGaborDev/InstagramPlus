//
//  EditProfileView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 25/09/2026.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: EditProfileViewModel
    
    init(user: User) {
        self.viewModel = .init(user: user)
    }
    
    var body: some View {
        VStack {
            //toolbar
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    Task{ try await viewModel.updateUserdata() }
                } label: {
                    Text("Done")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Divider()
        }
        
        //edit profile picture
        PhotosPicker(selection: $viewModel.selectedImage) {
            VStack {
                if let image = viewModel.profileImage {
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(Circle())
                }
                
                Text("Edit profile picture")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                Divider()
            }
        }
        .padding(.vertical, 6)
        
        
        //edit profile info
        VStack {
            EditProfileRowView(title: "Name", placeholder: "Enter your name..", text: $viewModel.fullname)
            EditProfileRowView(title: "Bio", placeholder: "Enter your bio..", text: $viewModel.bio)
        }
        Spacer()
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading)
                .frame(width: 100, alignment: .leading)
            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.footnote)
        .frame(height: 36)
    }
}

#Preview {
    EditProfileView(user: User.MOCK_USER[0])
}
