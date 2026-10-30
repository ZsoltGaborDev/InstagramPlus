//
//  FollowRequestCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/10/2026.
//

import SwiftUI

struct FollowRequestCell: View {
    let request: FollowRequest
    
    var body: some View {
        HStack {
            HStack {
                CircularProfileImageView(user: request.user, size: .medium)
                
                VStack(alignment: .leading, spacing: 2) {
                    if let user = request.user {
                        Text(user.username)
                            .fontWeight(.semibold)
                        if let fullname = user.fullname {
                            Text(fullname)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            HStack {
                Button {
                    print("DEBUG: Accept follow request tapped..")
                } label: {
                    Text("Accept")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 88, height: 34)
                        .background(.secondaryButtonBackground)
                        .foregroundStyle(.secondaryText)
                        .clipShape(.rect(cornerRadius: 6))
                }
                
                Button {
                    print("DEBUG: Reject follow request tapped..")
                } label: {
                    Text("Reject")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 88, height: 34)
                        .background(.primaryButtonBackground)
                        .foregroundStyle(.primaryText)
                        .clipShape(.rect(cornerRadius: 6))
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    FollowRequestCell(request: MockData.followRequests[0])
}
