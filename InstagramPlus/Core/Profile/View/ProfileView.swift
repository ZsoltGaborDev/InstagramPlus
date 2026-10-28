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
    @State private var profileViewModel: ProfileViewModel
    
    init(user: User) {
        self.user = user
        _profileViewModel = State(wrappedValue: ProfileViewModel(user: user))
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
            //header
            ProfileHeaderView(user: profileViewModel.user, actionHandler: handleFollowTapped)
            // post grid view
            if user.isPrivate {
                IGContentUnavailableView("This account is private.", systemImage: "lock.circle", description: "Request to follow this account to see their content")
                    .frame(height: 400)
            } else {
                PostGridView(viewModel: gridViewModel, configuration: .profile)
            }
        }
        .task {
            await profileViewModel.checkIfUserIsFollowed()
        }
        .task {
            await profileViewModel.fetchUserStats()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProfileView {
    func handleFollowTapped() {
        guard let isFollowed = profileViewModel.user.isFollowed else { return }
        isFollowed ?
        profileViewModel.unfollow() :
        profileViewModel.follow()
    }
}

#Preview {
    ProfileView(user: MockData.users[3])
}
