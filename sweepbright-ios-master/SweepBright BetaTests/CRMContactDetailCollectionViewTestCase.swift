//
//  CRMContactDetailCollectionViewTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class CRMContactDetailCollectionViewTestCase: XCTestCase {
    var viewController: CRMContactDetailCollectionViewController!
    var contact: CRMContact!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "CRMContactDetail", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as! CRMContactDetailCollectionViewController

        self.contact = CRMContact(value: ["first_name": "Bilbo", "last_name": "Baggings"])
        self.viewController.contact = contact

        UIApplication.sharedApplication().keyWindow!.rootViewController = self.viewController
    }

    func testTitle() {
        _ = self.viewController.view
        XCTAssertEqual(self.viewController.navigationItem.title, self.contact.fullName)
    }
}
