//
//  LoginViewModelTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import XCTest
@testable import InstagramPlus

@MainActor
final class LoginViewModelTests: XCTestCase {

    var mockService: MockAuthService!
    var authManager: AuthManager!
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockAuthService()
        authManager = AuthManager(service: mockService)
        viewModel = LoginViewModel()
    }
    
    override func tearDown() {
        mockService = nil
        authManager = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.error)
    }
    
    func testLoginSuccess() async {
        viewModel.email = "test@example.com"
        viewModel.password = "1validPassword!"
        
        await viewModel.login(with: authManager)
        
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testLoginFailure() async {
        mockService.errorToThrow = AuthenticationError.unknows
        
        viewModel.email = "test@example.com"
        viewModel.password = "1validPassword!"
        
        await viewModel.login(with: authManager)
        
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.showError)
    }
}
