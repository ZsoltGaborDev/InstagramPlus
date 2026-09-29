//
//  CommentsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import SwiftUI

struct CommentsView: View {
    
    @State private var commentText = ""
    @State var viewModel: CommentViewModel
    
    private var currentUser: User? {
        return UserService.shared.currentUser
    }
    
    init(post: Post) {
        self._viewModel = State(initialValue: CommentViewModel(post: post))
    }
    
    var body: some View {
        VStack {
            Text("Comments")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top, 24)
            
            Divider()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.comments, id: \.self) { comment in
                        CommentsCell(comment: comment)
                    }
                }
            }
            .padding(.top)
            
            Divider()
            
            HStack(spacing: 12) {
                CircularProfileImageView(user: currentUser, size: .xSmall)
                
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
                        Task {
                            try await viewModel.uploadComment(text: commentText)
                            commentText = ""
                        }
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
    }
}

#Preview {
    CommentsView(post: Post.MOCK_POSTS[0])
}
