//
//  LoginView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthManager
    @State var viewModel = LoginViewModel()
    @State var router = AuthenticationRouter()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            VStack {
                Spacer()
                
                //logo image
                Image("instagram")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                
                //text fields
                VStack {
                    TextField("Enter your  email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(IGPTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
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
                            await viewModel.login(with: authManager)
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
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
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
                
                Button {
                    router.startRegostration()
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
            .navigationDestination(for: RegistrationSteps.self) { step in
                Group {
                    switch step {
                    case .email:
                        AddEmailView()
                            .navigationBarBackButtonHidden()
                    case .username:
                        CreateUsernameView()
                    case .password:
                        CreatePasswordView()
                    case .completion:
                        CompleteSignUpView()
                    }
                }
                .environment(router)
            }
        }
    }
}

private extension LoginView {
    var formIsValid: Bool {
        return viewModel.email.isValidEmail() && viewModel.password.isValidPassword()
    }
}

#Preview {
    LoginView()
}
