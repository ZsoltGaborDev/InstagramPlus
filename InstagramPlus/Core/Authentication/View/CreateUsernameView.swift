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
            
            IGTextField("Enter your email", text: $viewModel.email)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
            
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .modifier(IGPTextFieldModifier())
            
            IGButton("Next", action: onNext)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.vertical)
            
            Spacer()
        }
    }
}

private extension CreateUsernameView {
    var formIsValid: Bool {
        return viewModel.username
            .isValidUsername()
    }
    
    func onNext() {
        Task {
            let usernameIsValid =  try await authManager.validateUsername(viewModel.username)
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
