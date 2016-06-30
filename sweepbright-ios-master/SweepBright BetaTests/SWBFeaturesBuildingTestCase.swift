//
//  SWBFeaturesBuildingTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class SWBFeaturesBuildingTestCase: XCTestCase {
    var tableView: SWBBuildingTableView!

    override func setUp() {
        super.setUp()
        self.tableView = SWBBuildingTableView(frame: CGRectMake(0, 0, 100, 100), style: .Plain)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testService() {
        let service = MockFeaturesService()
        self.tableView.service = service
        self.tableView.reloadData()

        XCTAssertFalse(service.yearBuiltSync)
        let yearCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! SWBYearBuiltCell
        yearCell.stepper.incrementButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssert(service.yearBuiltSync)
    }

    func testArchitectService() {
        let service = MockFeaturesService()
        self.tableView.service = service
        self.tableView.reloadData()

        XCTAssertFalse(service.architectSynced)

        let yearCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBArchitectCell
        yearCell.architectTextField.sendActionsForControlEvents(.EditingDidEnd)
        XCTAssert(service.architectSynced)
    }

    func testBindData() {
        let service = MockFeaturesService()
        service.property.features?.architect = "Arch"
        service.property.features?.yearBuilt.value = 1980

        self.tableView.service = service
        self.tableView.reloadData()

        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBArchitectCell
        XCTAssertEqual(cell.architectTextField.text, service.property.features?.architect)

        let yearCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! SWBYearBuiltCell
        XCTAssertEqual(yearCell.stepper.value, 1980)
    }
}
