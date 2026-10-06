//
//  AddEmailView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(AuthManager.self) var authManager
    @Environment(AuthenticationRouter.self) var router
    @Environment(RegistrationViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("You'll use this email to sign in to your account")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            IGTextField("Enter your email", text: $viewModel.email, error: $viewModel.error, isLoading: false)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .modifier(IGPTextFieldModifier())
            
            IGButton("next", action: onNext)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.vertical)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

private extension AddEmailView {
    var formIsValid: Bool {
        return viewModel.email
            .isValidEmail()
    }
    
    func onNext() {
        Task {
            let emailIsValid =  try await viewModel.validateEmail()
            if emailIsValid {
                router.navigate()
            } else {
                print("DEBUG: Email validation failed...")
            }
        }
    }
}

#Preview {
    AddEmailView()
}
