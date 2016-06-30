//
//  CRMPropertyTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/17/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift

@testable import SweepBright
class CRMPropertyTableViewControllerTestCase: XCTestCase {
    var viewController: CRMPropertyTableViewController!
    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        let storyboard = UIStoryboard(name: "SWBCRMMain", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("CRMPropertyTableViewController") as! CRMPropertyTableViewController
        _ = self.viewController.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func createDummyContact() -> CRMContact {
        let contact = CRMContact()
        let realm = try! Realm()
        realm.add(contact: contact)
        return contact
    }
}
