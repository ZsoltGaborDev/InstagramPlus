//
//  CommentsCellView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import SwiftUI

struct CommentsCell: View {
    let comment: Comment
    
    private var user: User? {
        return comment.user
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .xSmall)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(user?.username ?? "")
                        .fontWeight(.semibold)
                    
                    Text("6d")
                        .foregroundStyle(.gray)
                }
                
                Text(comment.text)
            }
            .font(.caption)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommentsCell(comment: dev.comment)
}
