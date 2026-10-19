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

    init(viewModel: PostGridViewModel) {
        self.viewModel = viewModel
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
    PostGridView(
        viewModel: PostGridViewModel(
            service: ProfilePostGridService(
                user: MockData.users[0]
            )
        )
    )
}
