//
//  CreateUsernameView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CreateUsernameView: View {
    @Environment(RegistrationViewModel.self) var viewModel
    @Environment(AuthenticationRouter.self) var router
    
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
            
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .modifier(IGPTextFieldModifier())
            
            Button {
                router.navigate()
            } label: {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.white))
                    .frame(width: 360, height: 40)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
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
}

#Preview {
    CreateUsernameView()
}
