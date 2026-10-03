//
//  ContentView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userManager: UserManager
    
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
}
