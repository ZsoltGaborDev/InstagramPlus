//
//  CompleteSignUpView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(RegistrationViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 12) {
            VStack {
                Text("Welcome to Instagram,")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text(viewModel.username)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Text("Click below to complete registration and start using Instagram")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            IGButton("Complete Sign Up", isLoading: viewModel.isLoading, action: onCompleteSignUpTapped)
                .padding(.vertical)
        }
        .alert("Ooops", isPresented: $viewModel.showError, actions: {}) {
            Text(viewModel.authError?.localizedDescription ?? "An unknown error occurred")
        }
    }
}

extension CompleteSignUpView {
    func onCompleteSignUpTapped() {
        Task { await viewModel.createUser(with: authManager) }
    }
}

#Preview {
    CompleteSignUpView()
}
