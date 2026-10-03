//
//  CurrentUserProfile.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    var user: User
    var posts: [Post] {
        return Post.MOCK_POSTS.filter({ $0.user?.username == user.username})
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //header
                ProfileHeaderView(user: user)
                
                //post grid view
                PostGridView(user: user)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            //try? await AuthService.shared.signOut()
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: User.MOCK_USER[0])
}
