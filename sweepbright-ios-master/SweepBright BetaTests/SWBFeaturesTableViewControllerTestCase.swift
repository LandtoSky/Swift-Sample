//
//  SWBFeaturesTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/24/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBFeaturesTableViewControllerTestCase: XCTestCase {
    var viewController: SWBFeaturesTableViewController!
    var service: MockFeaturesService! {
        didSet {
            self.viewController?.service = self.service
        }
    }

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBFeatures", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBFeaturesTableViewController") as! SWBFeaturesTableViewController
        self.service = MockFeaturesService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDelegates() {

        let property = SWBPropertyModel()
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertNotNil(self.viewController.bathroomSlider.delegate)
        XCTAssertNotNil(self.viewController.kitchenSlider.delegate)
        XCTAssertNotNil(self.viewController.comfortTableView.service)
        XCTAssertNotNil(self.viewController.hcTableView.service)
        XCTAssertNotNil(self.viewController.energySourceTableView.service)
        XCTAssertNotNil(self.viewController.securityTableView.service)
        XCTAssertNotNil(self.viewController.ecoTableView.service)
    }

    func testBindData() {
        let property = SWBPropertyModel()
        let features = SWBFeaturesModel(value: ["_kitchen": "mint", "_bathroom": "new"])
        property.features = features
        self.viewController.propertyDependent(property)
        self.viewController.features = features
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.bathroomSlider.getCondition(), SWBGeneralCondition.New)
        XCTAssertEqual(self.viewController.kitchenSlider.getCondition(), SWBGeneralCondition.Mint)
    }
}
