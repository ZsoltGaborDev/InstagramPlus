//
//  LogoutConfirmationView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 18/10/2026.
//

import SwiftUI

struct LogoutConfirmationView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss

    @State private var isLoggingOut = false
    @State private var showError = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: 72, height: 72)
                    .background(.red.opacity(0.1), in: Circle())
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("Log out?")
                        .font(.headline)

                    Text("You can log back in anytime to see what’s new.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    Button(role: .destructive) {
                        guard !isLoggingOut else { return }
                        isLoggingOut = true

                        Task { @MainActor in
                            defer { isLoggingOut = false }
                            do {
                                try await authManager.signOut()
                                dismiss()
                            } catch {
                                showError = true
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if isLoggingOut {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(isLoggingOut ? "Logging out…" : "Log Out")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                    .tint(.primary)
                }
                .disabled(isLoggingOut)
            }
            .padding(24)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(isLoggingOut)
        .alert("Couldn’t log out", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please try again.")
        }
    }
}

#Preview {
    LogoutConfirmationView()
        .environment(AuthManager(service: MockAuthService()))
}
