//
//  SWBPropertyDescriptionTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright

class SWBPropertyDescriptionTests: XCTestCase {

    class MockSWBDescriptionService: SWBDescriptionServiceProtocol {
        var executed = false
        var queue: NSOperationQueue! = NSOperationQueue()
        func updateDescriptionAndtitle(property: SWBDescriptionParameter) {
            executed = true
        }
    }

    var viewController: SWBPropertyDescription!
    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let storyboard = UIStoryboard(name: "SWBDescription", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBPropertyDescription") as! SWBPropertyDescription
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPopulateForm() {
        let property = SWBPropertyModel()
        property.desc = "This is a description"
        property.title = "Title"

        (self.viewController as PropertyDependent).propertyDependent(property)

        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.titleText.text, property.title)
        XCTAssertEqual(self.viewController.descriptionTextView.text, property.desc)
    }

    func testClearDescription() {
        let property = SWBPropertyModel()
        property.desc = "This is a description"
        property.title = "Title"

        (self.viewController as PropertyDependent).propertyDependent(property)

        let _ = self.viewController.view
        self.viewController.clearDescription(self)
        XCTAssertEqual(self.viewController.descriptionTextView.text, "")
        XCTAssertEqual(self.viewController.counterLabel.currentCounter, 0)

    }

    func testUpdateDate() {
        let property = SWBPropertyModel()
        property.desc = "This is a description"
        property.title = "Title"

        (self.viewController as PropertyDependent).propertyDependent(property)
        let _ = self.viewController.view
        let mockService = MockSWBDescriptionService()
        self.viewController.descriptionService = mockService
        XCTAssertFalse(mockService.executed)
        self.viewController.updateData()
        XCTAssert(mockService.executed)
    }
}
