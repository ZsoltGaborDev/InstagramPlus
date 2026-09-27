//
//  GridView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI
import Kingfisher

struct PostGridView: View {
    @State var viewModel: PostGridViewModel

    init(user: User) {
        _viewModel = State(initialValue: PostGridViewModel(user: user))
    }

    private let gridItems = Array(
        repeating: GridItem(.flexible(), spacing: 1),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1) {
            ForEach(viewModel.posts, id: \.id) { post in
                PostGridCellView(post: post)
            }
        }
    }
}

#Preview {
    PostGridView(user: User.MOCK_USER[0])
}
