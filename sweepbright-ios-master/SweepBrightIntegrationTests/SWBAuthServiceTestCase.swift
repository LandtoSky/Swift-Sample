//
//  SWBAuthServiceTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class SWBAuthServiceTestCase: SweepBrightIntegrationTests {
    class MockAuthServiceDelegate: NSObject, SWBAuthenticationServiceDelegate {
        var success = false
        var unsuccess = false
        var expectation: XCTestExpectation?

        func successfulSignIn() {
            self.success = true
            self.expectation?.fulfill()
        }
        func unsuccessfulSignIn(error: NSError?) {
            self.unsuccess = true
            self.expectation?.fulfill()
        }
    }
    var authService: SWBAuthService!
    var delegate: MockAuthServiceDelegate!

    override func setUp() {
        super.setUp()
        self.authService = SWBAuthService()
        self.delegate = MockAuthServiceDelegate()
        self.authService.delegate = self.delegate
    }

    func testEmailSignIn() {
        let asyncExpectation = expectationWithDescription(self.name!)
        self.delegate.expectation = asyncExpectation
        self.authService.signIn(withEmail: self.username)
        self.waitForExpectationsWithTimeout(30, handler: nil)

        XCTAssert(self.delegate.success)
    }
    func testInvalidEmailSignIn() {

        let asyncExpectation = expectationWithDescription(self.name!)
        self.delegate.expectation = asyncExpectation
        self.authService.signIn(withEmail: "")
        self.waitForExpectationsWithTimeout(30, handler: nil)

        XCTAssert(self.delegate.unsuccess)
    }
}
