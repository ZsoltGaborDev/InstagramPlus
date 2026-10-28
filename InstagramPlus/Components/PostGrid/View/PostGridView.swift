//
//  GridView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI
import Kingfisher

enum PostGridViewConfiguration {
    case profile
    case likedPosts
    case savedPosts
}

struct PostGridView: View {
    @State var viewModel: PostGridViewModel
    @State var selectedPost: Post?
    private let configuration: PostGridViewConfiguration

    init(viewModel: PostGridViewModel, configuration: PostGridViewConfiguration) {
        self.viewModel = viewModel
        self.configuration = configuration
    }

    private let gridItems = Array(
        repeating: GridItem(.flexible(), spacing: 1),
        count: 3
    )

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .empty:
                IGContentUnavailableView(emptyStateTitle, systemImage: emptyStateImageName, description: emptyStateDescription)
                    .frame(height: 400)
            case .error:
                Text("Failed to load posts..")
            case .loading:
                ProgressView()
                    .frame(height: 400)
            case .complete:
                LazyVGrid(columns: gridItems, spacing: 1) {
                    ForEach(viewModel.posts, id: \.id) { post in
                        PostGridCellView(post: post)
                            .onAppear { loadMorePosts(post) }
                            .onTapGesture { selectedPost = post }
                    }
                }
                .fullScreenCover(item: $selectedPost) { post in
                    PostGridFeedView(selectedPost: post, viewModel: viewModel)
                }
            }
        }
    }
}

private extension PostGridView {
    func loadMorePosts(_ lastPost: Post) {
        Task {
            guard lastPost == viewModel.posts.last else {return}
            await viewModel.fetchPosts()
        }
    }
}

private extension PostGridView {
    var emptyStateTitle: String {
        switch configuration {
        case .profile:
            "No Posts Yet"
        case .likedPosts:
            "No Liked Posts"
        case .savedPosts:
            "No Saved Posts."
        }
    }
    
    var emptyStateImageName: String {
        switch configuration {
        case .profile:
            "camera.circle"
        case .likedPosts:
            "heart.circle"
        case .savedPosts:
            "bookmark.circle"
        }
    }
    
    var emptyStateDescription: String? {
        switch configuration {
        case .profile:
            nil
        case .likedPosts:
            "Your liked posts will appear here. Tap the heart button on a post to save it."
        case .savedPosts:
            "Your saved posts will appear here. Tap the bookmark button on a post to save it."
        }
    }

}

#Preview {
    PostGridView(
        viewModel: PostGridViewModel(
            service: ProfilePostGridService(user: MockData.users[0]),
            likePostService: MockLikePostService(),
            savePostsService: MockSavedPostsService(),
            userService: MockUserService()
        ), configuration: .profile
    )
}
