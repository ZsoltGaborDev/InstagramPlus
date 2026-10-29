//
//  ProfileHeaderView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State private var isEditing: Bool = false
    
    private var user: User
    private var actionHandler: (() -> Void)
    
    init(user: User, actionHandler: @escaping (() -> Void)) {
        self.user = user
        self.actionHandler = actionHandler
    }
    
    private var isFollowed: Bool {
        return user.userRelationState == .followed
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
            .secondaryBackground :
            .primaryBackground
    }
    
    private var foregroundColor: Color {
        user.isCurrentUser || isFollowed ?
            .primaryBackground :
            .secondaryBackground
    }
    
    private var buttonBorderColor: Color {
        user.isCurrentUser || isFollowed ?
            .gray :
            .secondaryBackground
    }
    
    private var stats: UserStats {
        return user.stats ?? .init(followingCount: 0, followersCount: 0, postsCount: 0)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // pic and stats
            HStack {
                CircularProfileImageView(user: user, size: .large)
                
                Spacer()
                
                HStack{
                    UserStatView(value: stats.postsCount, title: "Posts")
                    
                    NavigationLink(value: UserListConfig.followers(uid: user.id)) {
                        UserStatView(value: stats.followersCount, title: "Followers")
                    }
                    
                    NavigationLink(value: UserListConfig.following(uid: user.id)) {
                        UserStatView(value: stats.followingCount, title: "Following")
                    }
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
                actionHandler()
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
        .navigationDestination(for: UserListConfig.self, destination: { config in
            UserListView(config: config)
        })
        .fullScreenCover(isPresented: $isEditing) {
            EditProfileView(user: user)
        }
    }
}



#Preview {
    ProfileHeaderView(user: MockData.users[0], actionHandler: {})
}
