//
//  CompleteSignUpView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(RegistrationViewModel.self) var viewModel
    
    var body: some View {
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
            
            Button {
                Task { await viewModel.createUser(with: authManager) }
            } label: {
                Text("Complete Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.white))
                    .frame(width: 360, height: 40)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    CompleteSignUpView()
}
