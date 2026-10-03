//
//  AuthService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import FirebaseAuth
import FirebaseFirestore

struct AuthService {
    
    func login(withEmail email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(email: String, password: String, username: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user.uid
        } catch {
            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func getUserSession() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
//    private func uploadUserData(uid: String, username: String, email: String) async throws {
//        let user = User(id: uid, username: username, email: email)
//        guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
//        
//        try? await FirebaseConstant
//            .UsersCollection
//            .document(user.id)
//            .setData(encodedUser)
//    }
    
}
