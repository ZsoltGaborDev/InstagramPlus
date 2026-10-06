//
//  RegistrationViewModelTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import XCTest
@testable import InstagramPlus

@MainActor
final class RegistrationViewModelTests: XCTestCase {

    var mockService: MockAuthService!
    var mockValidationService: MockRegistrationValidationService!
    var authManager: AuthManager!
    var viewModel: RegistrationViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockAuthService()
        mockValidationService = MockRegistrationValidationService()
        authManager = AuthManager(service: mockService)
        viewModel = RegistrationViewModel(service: mockValidationService)
    }
    
    override func tearDown() {
        mockService = nil
        mockValidationService = nil
        authManager = nil
        
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.error)
    }
    
    func testReset() {
        viewModel.email = "test@example.com"
        viewModel.password = "1ValidPassword!"
        viewModel.username = "validusername"
        
        viewModel.reset()
        
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.error)
    }
    
    func testCreateUserSuccess() async {
        viewModel.email = "test@example.com"
        viewModel.password = "1ValidPassword!"
        viewModel.username = "validusername"
        
        await viewModel.createUser(with: authManager)
        
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.error)
    }
    
    func testCreateUserFailure() async {
        viewModel.email = "test@example.com"
        viewModel.password = "1ValidPassword!"
        viewModel.username = "invalid username" // invalid username
        
        await viewModel.createUser(with: authManager)
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.error)
    }
    
    func testValidationEmailSuccess() async {
        viewModel.email = "test@example.com"
        do {
            let isValid = try await viewModel.validateEmail()
            XCTAssertTrue(isValid)
        } catch {
            XCTFail("Email validation failed with valid email address")
        }
    }
    
    func testValidationEmailFailure() async {
        viewModel.email = "invalidEmail.com"
        do {
            let isValid = try await viewModel.validateEmail()
            XCTAssertFalse(isValid)
        } catch {
            XCTFail("Validation email failure failed with invalid email")
        }
    }
    
    func testValidationUsernameSuccess() async {
        viewModel.username = "validUsername"
        do {
            let isValid = try await viewModel.validateUsername()
            XCTAssertTrue(isValid)
        } catch {
            XCTFail("Username validation failed with valid username")
        }
    }
    
    func testValidationUsernameFailure() async {
        do {
            let isValid = try await viewModel.validateUsername()
            XCTAssertFalse(isValid)
        } catch {
            XCTFail("Username validation failure failed with invalid username")
        }
    }
}
