//
//  MaskTextFieldTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class MaskTextFieldTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialZero() {
        let maskTestField = MaskTextField(frame: CGRect.zero)
        XCTAssertEqual(maskTestField.numberValue, 0)
        XCTAssertEqual(maskTestField.text, "0.00")
    }

    func testUpdateNumberValue() {
        let maskTestField = MaskTextField(frame: CGRect.zero)
        maskTestField.numberValue = 10
        XCTAssertEqual(maskTestField.text, "10.00")

        maskTestField.numberValue = 0.5
        XCTAssertEqual(maskTestField.text, "0.50")

        maskTestField.numberValue = 0.05
        XCTAssertEqual(maskTestField.text, "0.05")
    }

    func testUpdateText() {
        let maskTestField = MaskTextField(frame: CGRect.zero)
        maskTestField.text = "0.01"
        maskTestField.sendActionsForControlEvents(.EditingDidEnd)

        XCTAssertEqual(maskTestField.numberValue, 0.01)

        maskTestField.text = "0.55"
        maskTestField.sendActionsForControlEvents(.EditingDidEnd)

        XCTAssertEqual(maskTestField.numberValue, 0.55)


        maskTestField.text = "5.55"
        maskTestField.sendActionsForControlEvents(.EditingDidEnd)

        XCTAssertEqual(maskTestField.numberValue, 5.55)

        maskTestField.text = "500.55"
        maskTestField.sendActionsForControlEvents(.EditingDidEnd)

        XCTAssertEqual(maskTestField.numberValue, 500.55)


        maskTestField.text = "5,000.55"
        maskTestField.sendActionsForControlEvents(.EditingDidEnd)

        XCTAssertEqual(maskTestField.numberValue, 5000.55)
    }
}
