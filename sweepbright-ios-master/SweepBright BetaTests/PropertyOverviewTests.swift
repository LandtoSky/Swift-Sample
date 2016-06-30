//
//  PropertyOverviewTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/18/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class PropertyOverviewTests: XCTestCase {
    var viewController: PropertyOverviewViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBOverviewShared", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("PropertyOverviewViewController") as! PropertyOverviewViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMagicNumbers() {
        let property = SWBPropertyModel(value:["title":"testMagicNumbers"])
        self.viewController.property = property
        property.type = .House
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.hiperlinks.count, 9)
        XCTAssertEqual(self.viewController.numberOfSectionsInCollectionView(viewController.collectionView), 1)
        XCTAssertEqual(self.viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0), self.viewController.hiperlinks.count)
    }

    func testPropertyDependent() {
        let property = SWBPropertyModel(value:["title":"testMagicNumbers"])
        self.viewController.property = property
        let _ = self.viewController.view

        let propertyDependent: PropertyDependent = self.viewController
        propertyDependent.propertyDependent(SWBPropertyModel(value:["title":"testMagicNumbers"]))

        XCTAssertNotEqual(self.viewController.navigationItem.title, property.address)
    }

    func testcellForItemAtIndexPathWithSegue() {
        let property = SWBPropertyModel(value:["title":"testMagicNumbers"])
        property.status = .ForSale
        property.project = SWBProjectModel()
        self.viewController.property = property

        self.viewController.hiperlinks = [Hiperlink(name:"Location", icon: "\u{f041}", segue: "No where")]

        let _ = self.viewController.view

        let indexPath = NSIndexPath(forItem: 0, inSection: 0)

        let cell = self.viewController.collectionView(viewController.collectionView, cellForItemAtIndexPath: indexPath)
        XCTAssertEqual(cell.alpha, 1.0)
        XCTAssert(cell.userInteractionEnabled)
    }

    func testCellForItemAtIndexPathWithSegue() {
        let property = SWBPropertyModel(value:["title":"testMagicNumbers"])
        property.status = .ForSale
        property.project = SWBProjectModel()
        self.viewController.property = property

        let _ = self.viewController.view

        self.viewController.hiperlinks = [Hiperlink(name:"Location", icon: "\u{f041}", segue: nil)]

        let indexPath = NSIndexPath(forItem: 0, inSection: 0)

        let cell = self.viewController.collectionView(viewController.collectionView, cellForItemAtIndexPath: indexPath)
        XCTAssertEqual(cell.alpha, 0.5)
        XCTAssertFalse(cell.userInteractionEnabled)
    }

    func testUnitWhenPropertyIsAProject() {
        var property = SWBPropertyModel(value:["title":"units"])
        property.type = .House
        property.project = SWBProjectModel()

        self.viewController.property = property
        let _ = self.viewController.view
        XCTAssertEqual(self.viewController.dynamicLink.name.lowercaseString, "units")

        property = SWBPropertyModel(value:["title":"rooms"])
        self.viewController.property = property
        XCTAssertEqual(self.viewController.dynamicLink.name.lowercaseString, "rooms")

        property = SWBPropertyModel(value:["title":"rooms"])
        property.status = .ToLet
        self.viewController.property = property
        XCTAssertEqual(self.viewController.dynamicLink.name.lowercaseString, "rooms")
    }
}
