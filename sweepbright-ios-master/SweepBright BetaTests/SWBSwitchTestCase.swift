//
//  SWBSwitchTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright
class SWBSwitchTestCase: XCTestCase {

    func testHiddenOnButton() {
        let toggle = SWBSwitch(frame: CGRect.zero)
        XCTAssert(toggle.on)

        toggle.setOn(false)
        XCTAssertFalse(toggle.on)
        XCTAssert(toggle.buttonOn.hidden)

        toggle.setOn(true)
        XCTAssert(toggle.on)
    }

    func testButtonTargets() {
        let toggle = SWBSwitch(frame: CGRect.zero)
        XCTAssert(toggle.on)

        toggle.buttonOn.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertFalse(toggle.on)

        toggle.buttonOff.sendActionsForControlEvents(.TouchUpInside)
        XCTAssert(toggle.on)
    }

}
