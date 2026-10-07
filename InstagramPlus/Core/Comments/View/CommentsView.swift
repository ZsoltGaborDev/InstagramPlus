//
//  CommentsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import SwiftUI

struct CommentsView: View {
    @Environment(UserManager.self) private var userManager
    
    @State private var commentText = ""
    @State var viewModel: CommentViewModel
    
    init(post: Post) {
        self._viewModel = State(
            initialValue: CommentViewModel(
                post: post,
                commentService: CommentService(postId: post.id),
                userService: UserService()
            )
        )
    }
    
    var body: some View {
        VStack {
            Text("Comments")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top, 24)
            
            Divider()
            
            ScrollView {
                switch viewModel.loadingState {
                case .empty:
                    EmptyStateView("No comment yet.", systemImage: "bubble.circle", description: "Be the first to comment and add yours below")
                        .frame(height: 400)
                case .error:
                    Text("An error occured")
                case .loading:
                    ProgressView()
                case .complete:
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.comments, id: \.self) { comment in
                            CommentsCell(comment: comment)
                        }
                    }
                    .padding(.top)
                }
            }
        
            Divider()
            
            HStack(spacing: 12) {
                CircularProfileImageView(user: userManager.currentUser, size: .xSmall)
                
                ZStack(alignment: .trailing) {
                    TextField("Add a comments...", text: $commentText, axis: .vertical)
                        .font(.footnote)
                        .padding(12)
                        .padding(.trailing, 48)
                        .overlay {
                            Capsule()
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        }
                    Button {
                        uploadComment()
                    } label: {
                        Text("Post")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.systemBlue))
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .task { await viewModel.fetchComments() }
    }
}

private extension CommentsView {
    func uploadComment() {
        Task {
            guard let currentuser = userManager.currentUser else { return }
            let tempCommenText = commentText
            commentText = ""
            await viewModel.uploadComment(text: tempCommenText, currentUser: currentuser)
        }
    }
}
    

#Preview {
    CommentsView(post: MockData.posts[0])
}
