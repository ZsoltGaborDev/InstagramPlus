//
//  LoginView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct LoginView: View {
    @State var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //logo image
                Image("instagram")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                
                //text fields
                VStack {
                    TextField("Enter your  email", text: $loginVM.email)
                        .autocapitalization(.none)
                        .modifier(IGPTextFieldModifier())
                    
                    SecureField("Enter your password", text: $loginVM.password)
                        .modifier(IGPTextFieldModifier())
                    
                    Button {
                        print("Show forgot password")
                    } label: {
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.top)
                            .padding(.trailing, 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing )
                    
                    
                    Button {
                        Task {
                            try await loginVM.signIn()
                        }
                    } label: {
                        Text("Login")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.white))
                            .frame(width: 360, height: 40)
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                    }
                    .padding(.vertical)
                    
                    GeometryReader { proxy in
                        let totalWidth = proxy.size.width
                        let gap: CGFloat = 16
                        let textWidth: CGFloat = 24 // approximate width for "OR"; lines flex to fill
                        let lineWidth = max((totalWidth - textWidth - gap * 2) / 2, 0)
                        
                        HStack(spacing: gap) {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.4))
                                .frame(width: lineWidth, height: 1)
                            
                            Text("OR")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Rectangle()
                                .fill(Color.secondary.opacity(0.4))
                                .frame(width: lineWidth, height: 1)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Image("facebookLogo")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text("Continue with Facebook")
                            .foregroundStyle(Color(.systemBlue))
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    AddEmailView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                    
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    LoginView()
}
