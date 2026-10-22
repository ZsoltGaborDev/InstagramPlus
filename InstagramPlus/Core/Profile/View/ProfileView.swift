//
//  ProfileView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @State private var gridViewModel: PostGridViewModel
    
    init(user: User) {
        self.user = user
        _gridViewModel = State(
            wrappedValue: PostGridViewModel(
                service: SavedPostsGridService(),
                likePostService: LikePostService(),
                savePostsService: SavedPostsService(),
                userService: UserService()
            )
        )
    }
    
    var body: some View {
        ScrollView {
            ProfileHeaderView(user: user)
            PostGridView(viewModel: gridViewModel, configuration: .profile)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: MockData.users[3])
}
