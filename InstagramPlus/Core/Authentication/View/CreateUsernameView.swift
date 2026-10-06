//
//  CreateUsernameView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CreateUsernameView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(AuthenticationRouter.self) var router
    @Environment(RegistrationViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 12) {
            Text("Create username")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Pick an username for your new account. You can always change it later")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            IGTextField("Username", text: $viewModel.username, error: $viewModel.validationError, isLoading: viewModel.isValidating)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
            
            IGButton("Next", action: onNext)
                .disabled(!formIsValid || viewModel.isValidating)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.vertical)
            
            Spacer()
        }
        .onAppear {
            viewModel.validationError = nil
        }
    }
}

private extension CreateUsernameView {
    var formIsValid: Bool {
        return viewModel.username.isValidUsername()
    }
    
    func onNext() {
        Task {
            let usernameIsValid = await viewModel.validateUsername()
            if usernameIsValid {
                router.navigate()
            } else {
                print("DEBUG: Username validation failed...")
            }
        }
    }
}

#Preview {
    CreateUsernameView()
}
