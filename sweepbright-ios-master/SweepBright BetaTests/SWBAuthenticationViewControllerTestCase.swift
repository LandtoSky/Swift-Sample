//
//  SWBAuthenticationViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright

class SWBAuthenticationViewControllerTestCase: XCTestCase {
    var viewController: SWBAuthenticationViewController!

    class MockAuthService: NSObject, SWBAuthenticationService {
        var delegate: SWBAuthenticationServiceDelegate!
        var signed: Bool = false
        var registered: Bool = false
        func signIn(withEmail email: String) {

        }
        func signIn(username: String, password: String) {
            signed = true
        }

        func register(username: String, password: String) {
            registered = true
        }
    }

    class MockAuthServiceDelegate: NSObject, SWBAuthenticationServiceDelegate {
        var success: Bool = false
        var unsuccess: Bool = false

        func successfulSignIn() {
            success = true
        }

        func unsuccessfulSignIn(error: NSError?) {
            unsuccess = true
        }
    }
    var authDelegate: MockAuthServiceDelegate!
    var authService: MockAuthService!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBAuthentication", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBAuthenticationViewController") as! SWBAuthenticationViewController

        self.authDelegate = MockAuthServiceDelegate()
        self.authService = MockAuthService()

        self.viewController.authService = authService
        self.viewController.authDelegate = authDelegate
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        SWBKeychain.clear()
    }

    func testEmptyKeychaing() {

        SWBKeychain.clear()

        let _ = self.viewController.view
        self.viewController.viewDidAppear(false)

        XCTAssertFalse(authService.signed)
        XCTAssertFalse(authService.registered)

        XCTAssertFalse(authDelegate.success)
        XCTAssertFalse(authDelegate.unsuccess)
    }


    func testNotEmptyKeychaing() {
        let username = "access token"
        let password = "refresh token"

        SWBKeychain.set(username, forKey: .AccessToken)
        SWBKeychain.set(password, forKey: .RefreshToken)

        let _ = self.viewController.view
        self.viewController.handleAuthenticatedUser()
        XCTAssertFalse(authService.signed)
        XCTAssertFalse(authService.registered)
    }

    func testFormValidObserver() {
        let _ = self.viewController.view
        self.viewController.formValid = false

        XCTAssert(self.viewController.signInButton.hidden)
        XCTAssertFalse(self.viewController.alertLabel.hidden)

        self.viewController.formValid = true

        XCTAssertFalse(self.viewController.signInButton.hidden)
        XCTAssert(self.viewController.alertLabel.hidden)
    }
}
