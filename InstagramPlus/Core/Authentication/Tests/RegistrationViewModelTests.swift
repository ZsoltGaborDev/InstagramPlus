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
        XCTAssertNil(viewModel.authError)
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
        XCTAssertNil(viewModel.authError)
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
        XCTAssertNil(viewModel.authError)
    }
    
    func testCreateUserFailure() async {
        viewModel.email = "test@example.com"
        viewModel.password = "1ValidPassword!"
        viewModel.username = "invalid username" // invalid username
        
        await viewModel.createUser(with: authManager)
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.authError)
    }
    
    func testValidationEmailSuccess() async {
        viewModel.email = "test@example.com"
        let isValid = await viewModel.validateEmail()
        XCTAssertTrue(isValid)
    }
    
    func testValidationEmailFailure() async {
        viewModel.email = "invalidEmail.com"
        let isValid = await viewModel.validateEmail()
        XCTAssertFalse(isValid)
    }
    
    func testValidationUsernameSuccess() async {
        viewModel.username = "validUsername"
        let isValid = await viewModel.validateUsername()
        XCTAssertTrue(isValid)
    }
    
    func testValidationUsernameFailure() async {
        let isValid = await viewModel.validateUsername()
        XCTAssertFalse(isValid)
    }
}
