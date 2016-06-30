//
//  SWBLocationIntTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class SWBLocationIntTestCase: SweepBrightIntegrationTests {
    var token: dispatch_once_t = 0
    override func setUp() {
        super.setUp()

        dispatch_once(&token, {
            self.updateProperties()
        })
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func runUpdateLocation(withLocation location: SWBPropertyLocationModel) {

        let newStreet = NSUUID().UUIDString
        location.street = newStreet

        let asyncExpectation = expectationWithDescription(self.name!)

        let locationService = SWBLocationService()
        //Property id and location id are the same
        locationService.updateLocation(location.id, location: location, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)

        XCTAssertEqual(location.street, newStreet)
        self.updateProperty(withId: location.id)
        XCTAssertEqual(location.street, newStreet)
    }

    func testUpdateLocation() {
        let realm = try! Realm()
        let locationObject = realm.objects(SWBPropertyLocationModel.self).first!
        let location = SWBPropertyLocationModel(value: locationObject)
        self.runUpdateLocation(withLocation: location)
    }
    func testUpdateProjectLocation() {
        let realm = try! Realm()
        let project = realm.objects(SWBProjectModel.self).first!
        let location = SWBPropertyLocationModel(value: project.property!.location!)
        self.runUpdateLocation(withLocation: location)
    }
}
