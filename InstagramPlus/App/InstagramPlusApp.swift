//
//  InstagramPlusApp.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct InstagramPlusApp: App {
    @State private var authManager: AuthManager
    @State private var userManager: UserManager
    
    init() {
        FirebaseApp.configure()
        _authManager = State(wrappedValue: AuthManager(service: AuthService()))
        _userManager = State(wrappedValue: UserManager(service: UserService()))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(userManager)
        }
    }
}
