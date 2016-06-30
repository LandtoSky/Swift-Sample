//
//  PropertyUnitViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBUnitViewControllerTests: XCTestCase {
    var viewController: SWBUnitTableViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBEditTab", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBUnitTableViewController") as! SWBUnitTableViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
