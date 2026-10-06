//
//  AuthService.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 24/09/2026.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase

protocol AuthServiceProtocol {
    func createUser(email: String, password: String, username: String) async throws -> String
    func deleteAccount() async throws
    func login(withEmail email: String, password: String) async throws -> String
    func signOut() async throws
    func getUserSession() -> String?
    func sendResetPasswordLink(toEmail email: String) async throws
}

struct AuthService: AuthServiceProtocol {
    
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
            try await uploadUserData(uid: result.user.uid, username: username, email: email)
            return result.user.uid
        } catch {
            let authErrorCode = (error as NSError).code
            throw AuthenticationError(rawValue: authErrorCode)
        }
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        //TODO: implement delete account functionality
    }
    
    func getUserSession() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async throws {
        let user = User(id: uid, username: username, email: email)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
        
        try? await FirebaseConstant
            .UsersCollection
            .document(user.id)
            .setData(encodedUser)
    }
    
}

