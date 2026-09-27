//
//  IGPTextFieldModifier.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI
import Foundation

struct IGPTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .padding(.top)
    }
}
