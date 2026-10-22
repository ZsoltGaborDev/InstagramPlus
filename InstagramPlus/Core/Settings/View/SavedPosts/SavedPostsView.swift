//
//  SavedPostsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//

import SwiftUI

struct SavedPostsView: View {
    @State private var gridViewModel = PostGridViewModel(service: SavedPostsGridService(), likePostService: LikePostService(), savePostsService: SavedPostsService())
    
    var body: some View {
        ScrollView {
            PostGridView(viewModel: gridViewModel, configuration: .savedPosts)
        }
        .navigationTitle("Saved Posts")
    }
}

#Preview {
    SavedPostsView()
}
