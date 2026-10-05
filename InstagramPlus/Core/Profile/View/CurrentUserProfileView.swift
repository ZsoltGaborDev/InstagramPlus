//
//  CurrentUserProfile.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let user = userManager.currentUser {
                    ProfileHeaderView(user: user)
                    
                    PostGridView(user: user)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { try await authManager.signOut() }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
        .environment(AuthManager(service: MockAuthService()))
        .environment(UserManager(service: MockUserService()))
}
