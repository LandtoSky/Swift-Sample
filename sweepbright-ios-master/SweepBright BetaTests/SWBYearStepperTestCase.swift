//
//  SWBYearStepper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBYearStepperTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let stepper = SWBYearStepper(frame: CGRect.zero)

        XCTAssertNotNil(stepper.incrementButton)
        XCTAssertNotNil(stepper.decrementButton)
        XCTAssertNotNil(stepper.countTextField)
    }

    func testObservers() {
        let stepper = SWBYearStepper(frame: CGRect.zero)
        var changed = false
        stepper.maxValue = 2

        stepper.valueChangeBlock = {
            changed = true
        }
        XCTAssertEqual(stepper.countTextField.text, "0")
        XCTAssertFalse(changed)
        stepper.incrementValue(stepper.incrementButton)
        XCTAssert(changed)
        XCTAssertEqual(stepper.countTextField.text, "1")
    }

    func testDecrementButtonPress() {
        let stepper = SWBYearStepper(frame: CGRect.zero)
        stepper.incrementValue(stepper.incrementButton)

        stepper.decrementButton.sendActionsForControlEvents(.TouchUpInside)

        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.countTextField.text, "0")
    }

    func testIncrementButtonPress() {
        let stepper = SWBYearStepper(frame: CGRect.zero)
        stepper.value = 1
        stepper.maxValue = 10

        stepper.incrementButton.sendActionsForControlEvents(.TouchUpInside)

        XCTAssertEqual(stepper.value, 2)
        XCTAssertEqual(stepper.countTextField.text, "2")
    }

    func testMinValueDecrement() {
        let stepper = SWBYearStepper(frame: CGRect.zero)
        stepper.value = 0
        stepper.minValue = 0

        stepper.decrementButton.sendActionsForControlEvents(.TouchUpInside)

        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.countTextField.text, "0")
    }

    func testMaxValueDecrement() {
        let stepper = SWBYearStepper(frame: CGRect.zero)
        stepper.value = 0
        stepper.maxValue = 0

        stepper.incrementButton.sendActionsForControlEvents(.TouchUpInside)

        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.countTextField.text, "0")
    }

}
