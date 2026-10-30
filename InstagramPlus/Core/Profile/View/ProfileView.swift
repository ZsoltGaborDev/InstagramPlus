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
        _profileViewModel = State(
            wrappedValue: ProfileViewModel(
                user: user,
                followService: FollowService()
            )
        )
        _gridViewModel = State(
            wrappedValue: PostGridViewModel(
                service: ProfilePostGridService(user: user),
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
            await profileViewModel.fetchUserRelationState()
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
        switch profileViewModel.user.userRelationState {
        case .notFollowed:
            if profileViewModel.user.isPrivate {
                profileViewModel.sendFollowRequest()
            } else {
                profileViewModel.follow()
            }
        case .followed:
            profileViewModel.unfollow()
        case .requestedToFollow:
            print("DEBUG: Remove follow request")
        case .blocked:
            print("DEBUG: Unblock user..")
        default:
            break
        }
    }
}

#Preview {
    ProfileView(user: MockData.users[3])
}
