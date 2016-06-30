//
//  SWBNewPropertyTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class SWBNewPropertyTableViewControllerTestCase: XCTestCase {

    var viewController: SWBNewPropertyTableViewController!
    var service: MockPropertyService!
    var tableView: UITableView! {
        return self.viewController.tableView
    }

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBNewProperty", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBNewPropertyTableViewController") as! SWBNewPropertyTableViewController
        self.service = MockPropertyService()
        self.viewController.propertyService = self.service

        UIApplication.sharedApplication().keyWindow!.rootViewController = self.viewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSelectProject() {
        _ = self.viewController.view
        XCTAssertFalse(self.service.createdProperty)

        let projectIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.viewController.tableView(self.tableView, didSelectRowAtIndexPath: projectIndexPath)
        XCTAssertFalse(self.service.createdProperty)
    }

    func testSelectNotProject() {
        _ = self.viewController.view
        XCTAssertFalse(self.service.createdProperty)

        let indexPath = NSIndexPath(forItem: 0, inSection: 1)
        self.viewController.tableView(self.tableView, didSelectRowAtIndexPath: indexPath)
        XCTAssert(self.service.createdProperty)
    }
}
