//
//  SavedPostsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//

import SwiftUI

struct SavedPostsView: View {
    @State private var gridViewModel = PostGridViewModel(
        service: SavedPostsGridService(),
        likePostService: LikePostService(),
        savePostsService: SavedPostsService(),
        userService: UserService(),
        notificationManager: IGNotificationsManager(service: IGNotificationManagementService())
    )
    
    var body: some View {
        ScrollView {
            PostGridView(viewModel: gridViewModel, configuration: .savedPosts)
        }
        .refreshable {
            await gridViewModel.refreshPosts()
        }
        .navigationTitle("Saved Posts")
    }
}

#Preview {
    SavedPostsView()
}
