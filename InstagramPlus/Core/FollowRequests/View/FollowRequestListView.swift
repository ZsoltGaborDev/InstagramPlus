//
//  FollowRequestListView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/10/2026.
//

import SwiftUI

struct FollowRequestListView: View {
    @Environment(FollowRequestViewModel.self) private var viewModel
    var body: some View {
        ScrollView {
            switch viewModel.loadingState {
            case .empty:
                IGContentUnavailableView(
                    "Nothing to see here.",
                    systemImage: "paperplane.circle",
                    description: "Follow requests will appear here when users request to follow your account."
                )
                .containerRelativeFrame(.vertical)
            case .error:
                Text("An error occured..")
            case .loading:
                ProgressView()
            case .complete:
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.requests) { request in
                        FollowRequestCell(request: request)
                    }
                }
            }
        }
        .navigationTitle("Follow Requests")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
    }
}

#Preview {
    FollowRequestListView()
}
