//
//  FeedView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct FeedView: View {
    @State var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .empty:
                    Text("Empty state goes here...")
                case .error:
                    Text("An error occured..")
                case .loading:
                    ProgressView()
                case .complete:
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.posts) { post in
                                FeedCell(post: post)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FeedRouter.self, destination: { route in
                route.view
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("instagram")
                        .resizable()
                        .frame(width: 100, height: 30)

                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: FeedRouter.inbox) {
                        Image(systemName: "paperplane")
                            .imageScale(.large)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

#Preview {
    FeedView()
}
