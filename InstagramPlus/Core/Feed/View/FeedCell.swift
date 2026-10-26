//
//  FeedCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI
import Kingfisher

struct FeedCell<ViewModel>: View where ViewModel: FeedViewModelProtocol{
    let viewModel: ViewModel
    
    @State private var showComments = false
    @State private var showPostOptionsMenu = false

    private let post: Post
    
    init(post: Post, viewModel: ViewModel) {
        self.post = post
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            //image + username
            HStack {
                if let user = post.user {
                    CircularProfileImageView(user: user, size: .xSmall)
                    
                    NavigationLink(value: FeedRouter.profile(user)) {
                        Text(user.username)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primaryText)
                    }
                }
                
                Spacer()
                
                Button {
                    showPostOptionsMenu.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.primaryText)
                }
            }
            .padding(.horizontal, 8)
            
            //post image
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipShape(.rect)
            
            //action buttons
            HStack(spacing:16) {
                Button {
                    handleLikeTapped()
                } label: {
                    Image(systemName: post.didLike ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundColor(post.didLike ? .red : .primaryText)
                }
                
                Button {
                    showComments.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                }
                
                Button {
                    print("Share post")
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                }

                Spacer()
                
                Button {
                    handlePostSaveTapped()
                } label: {
                    Image(systemName: post.didSave ? "bookmark.fill" : "bookmark")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 4)
            .foregroundStyle(.primaryText)
            
            //likes label
            if likes > 0 {
                Text("\(likes) \(likes == 1 ? "like" : "likes")")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.top, 1)
            }
            
            //caption label
            HStack {
                Text("\(post.user?.username ?? "") \(Text(post.caption).fontWeight(.regular))").fontWeight(.semibold)
            }
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
            .padding(.top, 1)
            
            //timestamp label
            Text("\(post.timestamp.timestampString())")
                .foregroundColor(.gray)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 1)
        }
        .task { await viewModel.didLike(post) }
        .task { await viewModel.didSave(post) }
        .confirmationDialog("Post Options", isPresented: $showPostOptionsMenu, titleVisibility: .visible) {
            Button("Report", role: .destructive) {
                print("DEBUG: Show report sheet here..")
            }
        }
        .sheet(isPresented: $showComments, content: {
            CommentsView(post: post)
                .presentationDragIndicator(.visible)
        })
    }
    

}

private extension FeedCell {
    
    var postIndex: Int? {
        return viewModel.posts.firstIndex(where: { $0.id == post.id })
    }
    
    private var likes: Int {
        post.likes ?? 0
    }
    
    private func handleLikeTapped() {
        guard let postIndex else {return}
        Task {
            if viewModel.posts[postIndex].didLike {
                await viewModel.unlike(post)
            } else {
                await viewModel.like(post)
            }
        }
    }
    
    private func handlePostSaveTapped() {
        guard let postIndex else {return}
        Task {
            if viewModel.posts[postIndex].didSave {
                await viewModel.unsave(post)
            } else {
                await viewModel.save(post)
            }
        }
    }
}

#Preview {
    FeedCell(
        post: MockData.posts[0],
        viewModel: FeedViewModel(
            feedService: FeedService(),
            userService: MockUserService(),
            likePostService: LikePostService(),
            savePostsService: SavedPostsService()
        )
    )
}
