//
//  ContentView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) private var authManager
    
    @State var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        Group {
            if authManager.userSession == nil {
                LoginView()
                    .environment(registrationViewModel)
            } else {
                Text("Show Main Interface here..")
            }
        }
    }
}

#Preview {
    ContentView()
}
