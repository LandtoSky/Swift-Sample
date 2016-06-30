//
//  PropertyImageDetailViewControllerTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/21/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class PropertyImageDetailViewControllerTests: XCTestCase {

    var viewController: PropertyImageDetailViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SWBImage", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("PropertyImageDetailViewController") as! PropertyImageDetailViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCopy() {
        let propertyImage = PropertyImage(data: "", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view
        XCTAssertNotEqual(unsafeAddressOf(self.viewController.propertyImageEdit as! PropertyImage), unsafeAddressOf(propertyImage))
    }

    func testChangePropertyImage() {
        let propertyImage = PropertyImage(data: "Old", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view

        let newPropertyImage = PropertyImage(data: "New", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = newPropertyImage

        XCTAssertNotEqual(unsafeAddressOf(self.viewController.propertyImageEdit as! PropertyImage), unsafeAddressOf(newPropertyImage))
        XCTAssertFalse(self.viewController.hasChanged())
    }

    func testBackInformationDelegate() {
        let oldData = "Old Data"
        let propertyImage = PropertyImage(data: oldData, visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view
        let newValue = "New Value"
        self.viewController.returnInformation(self.viewController, info: [SWPDESCRIPTION:newValue])

        XCTAssertEqual(propertyImage.data, oldData)
        XCTAssertEqual(self.viewController.propertyImageEdit.data, newValue)
        XCTAssertEqual(self.viewController.descriptionText.text, newValue)
    }

    func testStartEditingDescription() {
        let propertyImage = PropertyImage(data: "Old", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.textViewShouldBeginEditing(self.viewController.descriptionText))
    }

    func testMarkAs() {

        let propertyImage = PropertyImage(data: "Old", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view

        self.viewController.markAs(self)

        XCTAssertEqual(self.viewController.propertyImage.visibility, Visibility.Private)
        XCTAssertEqual(self.viewController.propertyImageEdit.visibility, Visibility.Published)
    }

    func testSavingPhoto() {
        let propertyImage = PropertyImage(data: "Old", visibility: .Private, image: UIImage())
        self.viewController.propertyImage = propertyImage
        let _ = self.viewController.view

        let newData = "Has changed"
        self.viewController.propertyImageEdit.data = newData
        self.viewController.propertyImageEdit.visibility =  self.viewController.propertyImageEdit.visibility.opposite()

        self.viewController.updateData()

        XCTAssertEqual(newData, propertyImage.data)
        XCTAssertEqual(propertyImage.visibility, Visibility.Published)
    }
}
