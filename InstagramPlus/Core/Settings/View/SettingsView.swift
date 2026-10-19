//
//  SettingsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 18/10/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserManager.self) private var userManager

    @State private var isPrivateAccount = false
    @State private var showLogoutConfirmation = false

    var body: some View {
        List {
            Section {
                //profile view
                HStack {
                    CircularProfileImageView(user: userManager.currentUser, size: .large)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(userManager.currentUser?.fullname ?? "")
                            .fontWeight(.semibold)
                        Text(userManager.currentUser?.email ?? "")
                            .font(.footnote)
                    }
                }
            }

            Section("Privacy") {
                Toggle("Privacy Account", isOn: $isPrivateAccount)
                Text("Blocked Accounts")
            }

            Section("Activity") {
                ForEach(SettingsActivitySectionModel.allCases) { model in
                    NavigationLink(value: model) {
                        Text(model.description)
                    }
                }
            }

            Section("Legal") {
                Text("Terms & Conditions")
            }

            Section("Account") {
                Button("Log Out", role: .destructive) {
                    showLogoutConfirmation.toggle()
                }

                Button("Delete Account", role: .destructive) {

                }
            }
        }
        .sheet(isPresented: $showLogoutConfirmation) {
            LogoutConfirmationView()
        }
        .navigationDestination(for: SettingsActivitySectionModel.self) { model in
            switch model {
            case .savedPosts:
                SavedPostsView()
            case .likedPosts:
                LikedPostsView()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(UserManager(service: MockUserService()))
    .environment(AuthManager(service: MockAuthService()))
}
