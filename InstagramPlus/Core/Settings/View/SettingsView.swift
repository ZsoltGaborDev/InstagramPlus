//
//  SettingsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 18/10/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserManager.self) private var userManager

    @State private var isPrivateAccount = false
    @State private var showLogoutConfirmation = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
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
            .onAppear {
                onAppear()
            }
            .alert("Unsaved changed", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Leave Without Saving", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to exit without saving?")
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        updateUserPrivacyIfNecessary()
                    }
                }
            }
        }
    }
}

private extension SettingsView {
    var accountPrivacyDidChange: Bool {
        guard let currentUser = userManager.currentUser else { return false }
        return isPrivateAccount != currentUser.isPrivate
    }
    
    func onAppear() {
        self.isPrivateAccount = userManager.currentUser?.isPrivate ?? false
    }
    
    func onCancel() {
        accountPrivacyDidChange ?
        showAlert.toggle() :
        dismiss()
    }
    
    func updateUserPrivacyIfNecessary() {
        guard accountPrivacyDidChange else {
            dismiss()
            return
        }
        
        Task {
            await userManager.updateAccountPrivacy(isPrivateAccount)
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(UserManager(service: MockUserService()))
    .environment(AuthManager(service: MockAuthService()))
}
