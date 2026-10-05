//
//  ContentView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    @State var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        Group {
            if authManager.userSession == nil {
                LoginView()
                    .environment(registrationViewModel)
            } else {
                MainTabView()
            }
        }
        .task(id: authManager.userSession) {
            guard authManager.userSession != nil else { return }
            await userManager.fetchCurrentUser()
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthManager(service: MockAuthService()))
        .environment(UserManager(service: MockUserService()))   
}
