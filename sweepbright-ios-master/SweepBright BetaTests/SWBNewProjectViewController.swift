//
//  SWBNewProjectViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class SWBNewProjectViewControllerTestCase: XCTestCase {
    var viewController: SWBNewProjectViewController!

    var service: MockPropertyService!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBNewProperty", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBNewProjectViewController") as! SWBNewProjectViewController
        self.service = MockPropertyService()
        self.viewController.propertyViewController = self.service

        UIApplication.sharedApplication().keyWindow!.rootViewController = self.viewController
    }

    func testCallProjectMethod() {
        // Given
        _ = self.viewController.view
        let propertyTypeButton = SWBPropertyTypeButton(frame: CGRect.zero)
        propertyTypeButton.typeOfProperty = .House

        //When
        XCTAssertFalse(self.service.createdProject)
        self.viewController.addNewProperty(propertyTypeButton)

        //Then
        XCTAssert(self.service.createdProject)
    }

    func testDispatchNotification() {
        // Given
        _ = self.viewController.view
        var notificationDispatched = false

        NSNotificationCenter.defaultCenter().rac_addObserverForName(SWBNewPropertyAddedNotification.newPropertyNotificationName, object: nil).subscribeNext({ _ in notificationDispatched = true
        })

        //When
        let propertyTypeButton = SWBPropertyTypeButton(frame: CGRect.zero)
        propertyTypeButton.typeOfProperty = .House

        XCTAssertFalse(notificationDispatched)
        self.viewController.addNewProperty(propertyTypeButton)

        //Then
        XCTAssert(notificationDispatched)
    }
}
