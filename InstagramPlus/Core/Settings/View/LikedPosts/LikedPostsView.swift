//
//  SavedPostsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//


import SwiftUI

struct LikedPostsView: View {
    @State private var gridViewModel = PostGridViewModel(service: LikedPostsGridService())
    
    var body: some View {
        ScrollView {
            PostGridView(viewModel: gridViewModel, configuration: .likedPosts)
        }
        .navigationTitle("Liked Posts")
    }
}

#Preview {
    LikedPostsView()
}
