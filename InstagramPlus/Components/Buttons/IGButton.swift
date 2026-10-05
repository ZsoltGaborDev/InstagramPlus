//
//  IGButton.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import SwiftUI

struct IGButton: View {
    private let title: String
    private let action: () -> Void
    private let isLoading: Bool
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isLoading = false
    }
    
    init(_ title: String, isLoading: Bool, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Group{
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color(.white))
            .frame(width: 360, height: 40)
            .background(Color(.systemBlue))
            .cornerRadius(8)
        }

    }
}

#Preview {
    IGButton("Test", action: {})
}
