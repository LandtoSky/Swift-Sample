//
//  SWBRenovationTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright
class SWBRenovationTestCase: XCTestCase {

    var renovationTableView: SWBRenovationTableView!
    var service: MockFeaturesService!
    override func setUp() {
        super.setUp()
        self.renovationTableView = SWBRenovationTableView(frame: CGRectMake(0, 0, 100, 100), style: .Plain)
        self.service = MockFeaturesService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBindData() {
        service.property.features?.yearRenovated.value = 2000
        service.property.features?.renovationDetails = "Renovated"

        self.renovationTableView.service = self.service
        self.renovationTableView.reloadData()

        let detailsCell = self.renovationTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! SWBEditTextCell
        XCTAssertEqual(detailsCell.textView.text, self.service.property.features?.renovationDetails)

        let yearCell = self.renovationTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBRenovatedCell
        XCTAssertEqual(yearCell.stepper.value, self.service.property.features?.yearRenovated.value)
    }

    func testService() {
        self.renovationTableView.service = self.service
        self.renovationTableView.reloadData()

        let yearCell = self.renovationTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBRenovatedCell
        yearCell.stepper.incrementButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssert(self.service.yearRenovatedSynced)

    }
}
