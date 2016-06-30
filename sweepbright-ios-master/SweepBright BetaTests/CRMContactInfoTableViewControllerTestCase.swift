//
//  CRMContactInfoTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/31/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class CRMContactInfoTableViewControllerTestCase: XCTestCase {
    var viewController: CRMContactInfoTableViewController!
    var realm: Realm!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        super.setUp()
        let storyboard = UIStoryboard(name: "CRMContactInfo", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as! CRMContactInfoTableViewController!
        let id = "aee671b3-64ee-4162-bcf6-2faaa8303248"
        let contact = CRMContact(value: ["id": id])
        let address = CRMContactAddress(value: ["id": id, "contact": contact])
        contact.address = address
        self.realm = try! Realm()
        self.realm.saveOrUpdate(contact: contact)

        self.viewController.contact = realm.objectForPrimaryKey(CRMContact.self, key: id)
    }

    func testLoadWithoutContact() {
        self.viewController.contact = nil
        _ = self.viewController.view
        self.viewController.viewDidAppear(false)
        XCTAssertNil(self.viewController.contactForm.contact)
    }

    func testChangeStreet() {
        _ = self.viewController.view
        self.viewController.viewDidAppear(false)
        self.viewController.locationForm.streetTextField.text = "A"
        self.viewController.locationForm.streetTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertEqual("A", self.viewController.locationForm.location!.street)
    }
}
