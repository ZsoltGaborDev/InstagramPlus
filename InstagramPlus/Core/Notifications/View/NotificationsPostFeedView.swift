//
//  NotificationsPostFeedView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/11/2026.
//

import SwiftUI

struct NotificationsPostFeedView: View {
    @State private var feedViewModel = NotificationPostFeedViewModel()
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(feedViewModel.posts) { post in
                    FeedCell(post: post, viewModel: feedViewModel)
                }
            }
        }
        .navigationTitle("Post")
        .task{ await configureFeedViewModel(with: post) }
    }
}

private extension NotificationsPostFeedView {
    func configureFeedViewModel(with post: Post) async {
        self.feedViewModel.posts = [post]
        await feedViewModel.configurePostUserData()
    }
}

#Preview {
    NotificationsPostFeedView(post: MockData.posts[0])
}
