//
//  SWBGeneralConditionSliderTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBGeneralConditionSliderTestCase: XCTestCase {

    func testLabelOrder() {
        let slider = SWBGeneralConditionSlider(frame: CGRect.zero)
        XCTAssertEqual(slider.titlesLabel[0].lowercaseString, "poor")
        XCTAssertEqual(slider.titlesLabel[1].lowercaseString, "fair")
        XCTAssertEqual(slider.titlesLabel[2].lowercaseString, "good")
        XCTAssertEqual(slider.titlesLabel[3].lowercaseString, "mint")
        XCTAssertEqual(slider.titlesLabel[4].lowercaseString, "new")
    }

    func testTitleLabels() {
        let slider = SWBGeneralConditionSlider(frame: CGRect.zero)

        slider.setCondition(.Poor)
        XCTAssertEqual(slider.value, 0)

        slider.setCondition(.New)
        XCTAssertEqual(slider.value, 4)
    }

    func testCallServiceAfterChange() {
        let slider = SWBGeneralConditionSlider(frame: CGRect.zero)
        let delegate = MockRoomServiceDelegate()

        slider.roomDelegate = delegate
        slider.setCondition(.Good)

        XCTAssert(delegate.roomService.setGeneralConditionExecuted)
    }

}
