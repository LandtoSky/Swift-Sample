//
//  CRMSettingsTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class CRMSettingsTableViewControllerTestCase: XCTestCase {
    var viewController: CRMSettingsTableViewController!
    var queue: NSOperationQueue!
    var archived = false
    override func setUp() {
        super.setUp()
        self.archived = false
        let storyboard = UIStoryboard(name: "CRMSettings", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as! CRMSettingsTableViewController
    }

    func testArchiveAction() {
        let contact = CRMContact(value: ["first_name": "John", "last_name": "Snow"])
        self.viewController.contact = contact
        _ = self.viewController.view
        self.viewController.contactService = self
        XCTAssertFalse(self.archived)
        self.viewController.archiveButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssert(self.archived)
    }
}

extension CRMSettingsTableViewControllerTestCase: CRMContactService {
    func changeArchiveStatus(fromContact contact: CRMContact, completionBlock: (() -> ())?) {
        self.archived = true
        completionBlock?()
    }
}
