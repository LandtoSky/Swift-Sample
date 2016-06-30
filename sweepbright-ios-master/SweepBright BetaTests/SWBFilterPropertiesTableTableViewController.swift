//
//  SWBFilterPropertiesTableTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright

class SWBFilterPropertiesTableTableViewControllerTestCase: XCTestCase {
    var filterController: SWBFilterPropertiesTableTableViewController!
    var notified = false

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBFilterProperties", bundle: nil)
        self.filterController = storyboard.instantiateViewControllerWithIdentifier("SWBFilterPropertiesTableTableViewController") as? SWBFilterPropertiesTableTableViewController
        SWBFilter.sharedFilter = SWBFilter()
        self.notified = false
    }

    func testUpdateNegotiationFilter() {
        let _ = self.filterController.view

        self.filterController.negotiationSegment.selectedSegmentIndex = 0
        XCTAssertNil(self.filterController.filter!.negotiation)

        self.filterController.negotiationSegment.selectedSegmentIndex = 1
        self.filterController.negotiationSegment.sendActionsForControlEvents(.ValueChanged)
        XCTAssertEqual(self.filterController.filter!.negotiation, .ToLet)

        self.filterController.negotiationSegment.selectedSegmentIndex = 2
        self.filterController.negotiationSegment.sendActionsForControlEvents(.ValueChanged)
        XCTAssertEqual(self.filterController.filter!.negotiation, .ForSale)

        XCTAssertNil(SWBFilter.sharedFilter.negotiation)
    }

    func testPressFilterPropertyButton() {
        let _ = self.filterController.view

        self.filterController.filter.negotiation = .ForSale

        XCTAssertNil(SWBFilter.sharedFilter.negotiation)

        self.filterController.filterProperties(self)

        XCTAssertEqual(SWBFilter.sharedFilter.negotiation, .ForSale)
    }

    func observerNotified() {
        self.notified = true
    }

    func testFilterNotification() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SWBFilterPropertiesTableTableViewControllerTestCase.observerNotified), name: SWBFilterNotification, object: nil)

        SWBFilter.sharedFilter = SWBFilter()
        XCTAssert(notified)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func testPopulatingForm() {
        SWBFilter.sharedFilter.negotiation = .ToLet

        let _ = self.filterController.view

        XCTAssertEqual(self.filterController.negotiationSegment.negotiation, .ToLet)
    }
}
