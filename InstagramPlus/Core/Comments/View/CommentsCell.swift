//
//  CommentsCellView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 28/09/2026.
//

import SwiftUI

struct CommentsCell: View {
    
    private var user: User {
        return User.MOCK_USER[0]
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .xSmall)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(user.username)
                        .fontWeight(.semibold)
                    
                    Text("6d")
                        .foregroundStyle(.gray)
                }
                
                Text("You're looking just gorgeous today!")
            }
            .font(.caption)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommentsCell()
}
