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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post, viewModel: viewModel)
                    }
                }
            }
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
        viewModel: PostGridViewModel(
            service: SavedPostsGridService(),
            likePostService: MockLikePostService(),
            savePostsService: MockSavedPostsService()
        )
    )
}
