//
//  GridView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 21/09/2026.
//

import SwiftUI

struct GridView: View {
    
    var posts: [Post]
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let itemSize = (width / 3) - 1
            let count = posts.count
            let rows = (count + 2) / 3 // integer ceil(count/3)
            let totalHeight = CGFloat(rows) * itemSize + CGFloat(rows - 1) * 1

            VStack(spacing: 0) {
                LazyVGrid(columns: gridItems, spacing: 1) {
                    ForEach(posts) { post in
                        Image(post.imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: itemSize, height: itemSize)
                            .clipped()
                    }
                }
                .frame(width: width)
            }
            .frame(height: totalHeight, alignment: .top)
        }
    }
}

#Preview {
    GridView(posts: Post.MOCK_POSTS)
}
