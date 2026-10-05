//
//  CreatePasswordView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(RegistrationViewModel.self) var viewModel
    @Environment(AuthenticationRouter.self) var router
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 12) {
            Text("Create a password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Your password must be at least 5 characters in lenght")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            SecureField("Password", text: $viewModel.password)
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

private extension CreatePasswordView {
    var formIsValid: Bool {
        return viewModel.password.isValidPassword()
    }
    
    func onNext() {
        router.navigate()
    }
}

#Preview {
    CreatePasswordView()
}
