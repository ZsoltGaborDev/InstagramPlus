//
//  CurrentUserProfile.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CurrentUserProfileView: View {
    private enum Destination: Int, Identifiable {
        case settings
        case editProfile
        
        var id: Int { return self.rawValue }
    }

    @Environment(UserManager.self) private var userManager
    
    @State private var destination: Destination?
    @State private var gridViewModel = PostGridViewModel(
        service: ProfilePostGridService(),
        likePostService: LikePostService(),
        savePostsService: SavedPostsService(),
        userService: UserService()
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let user = userManager.currentUser {
                    ProfileHeaderView(user: user) {
                        destination = .editProfile
                    }
                    
                    PostGridView(viewModel: gridViewModel, configuration: .profile)
                }
            }
            .refreshable {
                await userManager.fetchCurrentUser()
                await userManager.fetchUserStats()
            }
            .task(id: userManager.currentUser?.id) {
                await userManager.fetchUserStats()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        destination = .settings
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
            .fullScreenCover(item: $destination) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                case .editProfile:
                    if let user = userManager.currentUser {
                        EditProfileView(user: user)
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
        .environment(AuthManager(service: MockAuthService()))
        .environment(UserManager(service: MockUserService()))
}
