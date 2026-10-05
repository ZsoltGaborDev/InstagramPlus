//
//  AuthService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase

struct AuthService {
    
    func login(withEmail email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            let authErrorCode = (error as NSError).code
            throw AuthenticationError(rawValue: authErrorCode)
        }
    }
    
    func createUser(email: String, password: String, username: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user.uid
        } catch {
            let authErrorCode = (error as NSError).code
            throw AuthenticationError(rawValue: authErrorCode)
        }
    }
    
    func validateEmail(_ email: String) async throws -> Bool {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .whereField("email", isEqualTo: email)
            .getDocuments()
        
        return snapshot.isEmpty
    }
    
    func validateUsername(_ username: String) async throws -> Bool {
        let snapshot = try await FirebaseConstant
            .UsersCollection
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        return snapshot.isEmpty
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
