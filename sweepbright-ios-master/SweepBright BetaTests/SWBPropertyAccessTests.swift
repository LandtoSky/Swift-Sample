//
//  SWBPropertyAccessTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright

class SWBPropertyAccessTests: XCTestCase {

    var viewController: SWBAccessTableViewController!
    var service: MockAccessService!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SWBAccess", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBAccessTableViewController") as! SWBAccessTableViewController
        self.service = MockAccessService()
        self.viewController.service = self.service
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewDidLoad() {
        //By default, all switch are on
        let property = SWBPropertyModel(value:["title":"Property Model"])
        let access = Access()
        access.currentlyVacant = false
        access.keyInPossesion = false
        access.alarmOnProperty = false
        access.alarmCode = "testViewDidLoad"
        access.details = "testViewDidLoad"
        property.access = access

        self.viewController.propertyDependent(property)

        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.currentlyVacant.on)
        XCTAssertFalse(self.viewController.alarmOnProperty.on)
        XCTAssertFalse(self.viewController.keyInPossession.on)
        XCTAssertEqual(self.viewController.alarmCodeTextField.text, access.alarmCode)
        XCTAssertEqual(self.viewController.detailsTextView.text, property.access!.details)
    }

    func testShowAlarmCode() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssert(self.viewController.alarmCodeTextField.secureTextEntry)
        self.viewController.hideAlarmCode(self)
        XCTAssertFalse(self.viewController.alarmCodeTextField.secureTextEntry)
        self.viewController.hideAlarmCode(self)
        XCTAssert(self.viewController.alarmCodeTextField.secureTextEntry)
    }

    func testHasChanged() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.hasChanged())
        self.viewController.alarmOnProperty.setOn(!self.viewController.alarmOnProperty.checked)
        XCTAssert(self.viewController.hasChanged())
    }

    func testUpdateProperty() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        let realm = try! Realm()
        try! realm.write({
            realm.add(property)
        })

        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertFalse(property.access!.alarmOnProperty)
        self.viewController.alarmOnProperty.setOn(true)
        XCTAssertFalse(property.access!.alarmOnProperty)
        XCTAssertFalse(self.service.synced)
        self.viewController.updateData()
        XCTAssert(property.access!.alarmOnProperty)
        XCTAssert(self.service.synced)
    }
}
