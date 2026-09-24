//
//  AuthService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

@Observable
final class AuthService {
    
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        Task { try? await loadUserData() }
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("password: \(password)")
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
        }
    }
    
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
        }
    }
    
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else {return}
        let snapshot = try? await Firestore.firestore().collection("users").document(currentUid).getDocument()
        if let userData = snapshot?.data() {
            self.currentUser = try? Firestore.Decoder().decode(User.self, from: userData)
        }
    }
    
    func signOut() async throws {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async throws {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
        
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
}
