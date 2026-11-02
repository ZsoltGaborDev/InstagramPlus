//
//  FollowRequestCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/10/2026.
//

import SwiftUI

struct FollowRequestCell: View {
    @Environment(FollowRequestViewModel.self) private var viewModel
    let request: FollowRequest
    
    var body: some View {
        HStack {
            HStack {
                CircularProfileImageView(user: request.user, size: .medium)
                
                VStack(alignment: .leading, spacing: 2) {
                    if let user = request.user {
                        Text(user.username)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primaryText)
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
                    Task { await viewModel.accept(request) }
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
                    Task { await viewModel.reject(request) }
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
