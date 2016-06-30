//
//  CounterLabelTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class CounterLabelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCounterUpdated() {
        let label = CounterLabel(frame: CGRect.zero)
        XCTAssertEqual(label.getCounter(), 0)
        label.currentCounter = 1
        XCTAssertEqual("\(label.getCounter())", label.text)
        XCTAssertEqual(label.getCounter(), 139)
        XCTAssertEqual("\(label.getCounter())", label.text)

        label.maxCharacters = 1
        XCTAssertEqual(label.getCounter(), 0)
        XCTAssertEqual("\(label.getCounter())", label.text)
    }

    func testNormalColor() {
        let label = CounterLabel(frame: CGRect.zero)
        label.currentCounter = 0
        label.maxCharacters = 140

        XCTAssertEqual(label.textColor, label.normalColor)
    }
    func testNormalColorWhenCounterIsZero() {
        let label = CounterLabel(frame: CGRect.zero)
        label.currentCounter = 140
        label.maxCharacters = 140

        XCTAssertEqual(label.textColor, label.normalColor)
    }


    func testNegativeColor() {
        let label = CounterLabel(frame: CGRect.zero)
        label.currentCounter = 1
        label.maxCharacters = 0

        XCTAssertEqual(label.textColor, label.negativeColor)
    }
}
