//
//  AuthenticationRouterTests.swift
//  InstagramPlusTests
//
//  Created by Zsolt Gabor on 05/10/2026.
//

import XCTest
@testable import InstagramPlus

final class AuthenticationRouterTests: XCTestCase {
    var router: AuthenticationRouter!
    
    override func setUp() {
        super.setUp()
        router = AuthenticationRouter()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func testStartRegostration() {
        router.startRegistration() // [.email]
        
        XCTAssertEqual(router.navigationPath.count, 1)
        XCTAssertEqual(router.navigationPath.first, RegistrationSteps(rawValue: 0))
    }
    
    func testNavigationToNextStep() {
        router.startRegistration() // [.email, .username]
        router.navigate()
        
        XCTAssertEqual(router.navigationPath.count, 2)
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps(rawValue: 1))
    }
    
    func testnavigationToCompletion() {
        router.navigationPath.append(contentsOf: RegistrationSteps.allCases)
        
        XCTAssertEqual(router.navigationPath.count, RegistrationSteps.allCases.count)
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps.completion)
    }
    
    func testNavigationBeyondCompletion() {
        router.navigationPath.append(contentsOf: RegistrationSteps.allCases)
        router.navigate() // attempt to navigate poast completion
        
        XCTAssertEqual(router.navigationPath.count, RegistrationSteps.allCases.count)
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps.completion)
    }
    
    func testResetRouter() {
        router.startRegistration()
        router.navigate()
        router.reset()
        
        XCTAssertTrue(router.navigationPath.isEmpty)
        XCTAssertNil(router.currentStep)
    }
    
    func testCurrentStepIsCorrectValue() {
        router.startRegistration()
        
        XCTAssertNotNil(router.currentStep)
        XCTAssertEqual(router.navigationPath.last, router.currentStep)
    }
    
    func testEmptyNavigationDoesNotCrashNavigate() {
        router.navigate()
        
        XCTAssertEqual(router.navigationPath.count, 0)
        XCTAssertNil(router.currentStep)
    }
}


