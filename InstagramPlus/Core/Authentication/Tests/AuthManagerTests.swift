//
//  AuthManagerTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import XCTest
@testable import InstagramPlus

@MainActor
final class AuthManagerTests: XCTestCase {
    var mockService: MockAuthService!
    var authManager: AuthManager!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthService()
        authManager = AuthManager(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        authManager = nil
        super.tearDown()
    }
    
    func testLoginSuccess() async {
        try? await authManager.login(with: "test@gmail.com", password: "qqqqq")
        XCTAssertNotNil(authManager.userSession)
    }
    
    func testLoginFailure() async {
        authManager.userSession = nil
        mockService.errorToThrow = .unknows
        
        try? await authManager.login(with: "test@gmail.com", password: "qqqqq")
        XCTAssertNil(authManager.userSession)
    }
    
    func testLoginWithInvalidEmail() async {
        authManager.userSession = nil
        
        try? await authManager.login(with: "invalidEmail", password: "qqqqq")
        XCTAssertNil(authManager.userSession)
    }
    
    func testLoginWithWrongPassword() async {
        authManager.userSession = nil
        
        try? await authManager.login(with: "test@email.com", password: "invalidPassword")
        XCTAssertNil(authManager.userSession)
    }
    
    func testCreateUserSuccess() async {
        try? await authManager.createUser(
            withEmail: "test@gmail.com",
            password: "1@Password",
            usermame: "testusername")
        
        XCTAssertNotNil(authManager.userSession)
    }
    
    func testCreateUserFailure() async {
        authManager.userSession = nil
        mockService.errorToThrow = .unknows
        
        try? await authManager.createUser(
            withEmail: "test@gmail.com",
            password: "1@Password",
            usermame: "testusername")
        
        XCTAssertNil(authManager.userSession)
    }
    
    func testCreateUserFailureWithInvalidUsername() async {
        authManager.userSession = nil
        
        try? await authManager.createUser(
            withEmail: "test@gmail.com",
            password: "1@Password",
            usermame: "invalid Username")
        
        XCTAssertNil(authManager.userSession)
    }
    
    func testSignOut() async {
        try? await authManager.signOut()
        XCTAssertNil(authManager.userSession)
    }
    
    func testValidationEmailSuccess() async {
        do {
            let isValid = try await authManager.validateEmail("valid@email.com")
            XCTAssertTrue(isValid)
        } catch {
            XCTFail("Email validation failed with valid email address")
        }
    }
    
    func testValidationEmailFailure() async {
        do {
            let isValid = try await authManager.validateEmail("invalidemail")
            XCTAssertFalse(isValid)
        } catch {
            XCTFail("Validation email failure failed with invalid email")
        }
    }
    
    func testValidationUsernameSuccess() async {
        do {
            let isValid = try await authManager.validateUsername("validusername")
            XCTAssertTrue(isValid)
        } catch {
            XCTFail("Username validation failed with valid username")
        }
    }
    
    func testValidationUsernameFailure() async {
        do {
            let isValid = try await authManager.validateUsername("invalid username")
            XCTAssertFalse(isValid)
        } catch {
            XCTFail("Username validation failure failed with invalid username")
        }
    }
    
    func testDeleteAccountSuccess() async {
        do {
            try await authManager.deleteAccount()
            XCTAssertTrue(mockService.didCallDeleteAccount)
        } catch {
            XCTFail("Delete account failed")
        }
    }
    
    func testSendResetPasswordLinkSuccess() async {
        do {
            try await authManager.sendResetPasswordLink(toEmail: "test@example.com")
            XCTAssertTrue(mockService.didCallSendResetPassword)
        } catch {
            XCTFail("Send reset password failed for valid email")
        }
    }
}
