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
    var authManager: AuthManager!
    var viewModel: RegistrationViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockAuthService()
        authManager = AuthManager(service: mockService)
        viewModel = RegistrationViewModel()
    }
    
    override func tearDown() {
        mockService = nil
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
}
