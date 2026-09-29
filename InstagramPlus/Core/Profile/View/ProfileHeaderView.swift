//
//  ProfileHeaderView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State var viewModel: ProfileViewModel
    @State private var isEditing: Bool = false
    
    private var user: User {
        return viewModel.user
    }
    
    private var isFollowed: Bool {
        return user.isFollowed ?? true
    }
    
    private var buttonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return isFollowed ? "Unfollow" : "Follow"
        }
    }
    
    private var backgroundColor: Color {
        user.isCurrentUser || isFollowed ?
            .white :
            .black
    }
    
    private var foregroundColor: Color {
        user.isCurrentUser || isFollowed ?
            .black :
            .white
    }
    
    private var buttonBorderColor: Color {
        user.isCurrentUser || isFollowed ?
            .gray :
            .clear
    }
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
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
                    handleFollowTapped()
                }
            } label: {
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 32)
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(buttonBorderColor, lineWidth: 1)
                    )
            }
            Divider()
        }
        .fullScreenCover(isPresented: $isEditing) {
            EditProfileView(user: user)
        }
    }
    
    func handleFollowTapped() {
        isFollowed ?
        viewModel.unfollow() :
        viewModel.follow()
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USER[0])
}
