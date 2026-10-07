//
//  FeedCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    let viewModel: FeedViewModel
    
    @State private var showComments = false
    @State private var showPostOptionsMenu = false

    private let post: Post
    
    init(post: Post, viewModel: FeedViewModel) {
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
                    }
                }
                
                Spacer()
                
                Button {
                    showPostOptionsMenu.toggle()
                } label: {
                    Image(systemName: "ellipsis")
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
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundColor(didLike ? .red : .black)
                }
                
                Button {
                    showComments.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
                
                Button {
                    print("Share post")
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }

                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 4)
            
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
        .task {
            await viewModel.checkIfUserLikedPost(post)
        }
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
    
    private var didLike: Bool {
        return post.didLike ?? false
    }
    
    private func handleLikeTapped() {
        guard let postIndex else {return}
        Task {
            if viewModel.posts[postIndex].didLike ?? false {
                try await viewModel.unlike(post)
            } else {
                try await viewModel.like(post)
            }
        }
    }
}

#Preview {
    FeedCell(
        post: MockData.posts[0],
        viewModel: FeedViewModel(
            feedService: FeedService(),
            userService: MockUserService()
        )
    )
}
