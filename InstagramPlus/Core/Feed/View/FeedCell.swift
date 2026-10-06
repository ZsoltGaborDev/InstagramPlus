//
//  FeedCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    @State private var showComments = false
    
    let viewModel: FeedCellViewModel
    
    private var post: Post {
        return viewModel.post
    }
    
    private var likes: Int {
        post.likes ?? 0
    }
    
    private var didLike: Bool {
        return post.didLike ?? false
    }
    
    init(post: Post) {
        self.viewModel = FeedCellViewModel(post: post)
    }
    
    var body: some View {
        VStack {
            //image + username
            HStack {
                if let user = post.user {
                    CircularProfileImageView(user: user, size: .xSmall)
                    
                    Text(user.username)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .padding(.leading, 8)
            
            //post image
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipShape(Rectangle())
            
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
        .sheet(isPresented: $showComments, content: {
            CommentsView(post: post)
                .presentationDragIndicator(.visible)
        })
    }
    
    private func handleLikeTapped() {
        Task { didLike ?
            try await viewModel.unlike() :
            try await viewModel.like()
        }
    }
}

#Preview {
    FeedCell(post: Post.MOCK_POSTS[0])
}
