//
//  IGContentUnavailableView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 07/10/2026.
//

import SwiftUI

struct IGContentUnavailableView: View {
    private let title: String
    private let systemImage: String
    private let description: String?
    
    init(_ title: String, systemImage: String, description: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: 100, height: 100)
                .fontWeight(.ultraLight)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(description ?? "")
                .foregroundStyle(.gray)
                .font(.subheadline)
                .padding(.horizontal, 32)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    IGContentUnavailableView(
        "No comments yet",
        systemImage: "bubble.circle",
        description: "Nothing to see here"
    )
}
