//
//  CurrentUserProfile.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CurrentUserProfileView: View {
    private enum Destination: Hashable {
        case settings
    }

    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    @State private var gridViewModel = PostGridViewModel(service: ProfilePostGridService())
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let user = userManager.currentUser {
                    ProfileHeaderView(user: user)
                    
                    PostGridView(viewModel: gridViewModel)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: Destination.settings) {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
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
