//
//  PostGridFeedView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 22/10/2026.
//

import SwiftUI

struct PostGridFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: PostGridViewModel
    @State private var scrollPosition: String?
    
    init(selectedPost: Post, viewModel: PostGridViewModel) {
        _scrollPosition = State(initialValue: selectedPost.id)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post, viewModel: viewModel)
                            .id(post.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPosition, anchor: .top)
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}

#Preview {
    PostGridFeedView(
        selectedPost: MockData.posts[0],
        viewModel: PostGridViewModel(
            service: SavedPostsGridService(),
            likePostService: MockLikePostService(),
            savePostsService: MockSavedPostsService(),
            userService: MockUserService()
        )
    )
}
