//
//  SWBAccessTokenTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBAccessTokenTests: SweepBrightIntegrationTests {
    override func setUp() {
        SWBKeychain.clear()
        super.setUp()
    }
    func testGetAccessToken() {
        let accessTokenOP = SWBRoutes.getAccessToken()
        self.runAsyncTest(accessTokenOP)
        XCTAssertNotNil(SWBKeychain.get(.AccessToken))
        XCTAssertNotNil(SWBKeychain.get(.RefreshToken))
    }

    func testGetAccessTokenWithEmptyData() {
        let accessTokenOP = SWBRoutes.getAccessToken()
        SWBKeychain.clear()

        XCTAssertNil(SWBKeychain.get(.AccessToken))
        self.runAsyncTest(accessTokenOP)

        XCTAssertNil(SWBKeychain.get(.AccessToken))
        XCTAssertNil(SWBKeychain.get(.RefreshToken))
    }
}
