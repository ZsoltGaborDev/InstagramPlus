//
//  ProfileHeaderView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            // pic and stats
            HStack {
                CircularProfileImageView(user: user, size: .large)
                
                Spacer()
                
                HStack{
                    UserStatView(value: 43, title: "Posts")
                    
                    UserStatView(value: 112, title: "Followers")
                    
                    UserStatView(value: 92, title: "Following")
                }
            }
            .padding(.horizontal)
            
            //name and bio
            VStack(alignment: .leading, spacing: 4) {
                if let fullName = user.fullname {
                    Text(fullName)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            //action button
            Button {
                if user.isCurrentUser {
                    isEditing.toggle()
                } else {
                    
                }
            } label: {
                Text(user.isCurrentUser ? "Edit Profile" :  "Follow")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 32)
                    .background(user.isCurrentUser ? .white : .black)
                    .foregroundColor(user.isCurrentUser ? .black : .white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(user.isCurrentUser ? Color.gray : .clear, lineWidth: 1)
                    )
            }
            Divider()
        }
        .fullScreenCover(isPresented: $isEditing) {
            EditProfileView(user: user)
        }
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USER[0])
}
