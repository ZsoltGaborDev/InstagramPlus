//
//  ContentView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthManager
    
    @State var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        Group {
            if authManager.userSession == nil {
                LoginView()
                    .environment(registrationViewModel)
            } else if let currentUser = authManager.currentUser {
                MainTabView(user: currentUser)
            } else {
                Text("User logged in..")
            }
        }
    }
}

#Preview {
    ContentView()
}
