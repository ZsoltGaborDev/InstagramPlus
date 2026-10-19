//
//  PostGridViewCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 27/09/2026.
//

import SwiftUI
import Kingfisher

struct PostGridCellView: View {
    let post: Post

    var body: some View {
        GeometryReader { proxy in
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.width
                )
                .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
