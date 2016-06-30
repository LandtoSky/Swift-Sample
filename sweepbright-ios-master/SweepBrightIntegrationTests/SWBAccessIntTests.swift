//
//  SWBAccessIntTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class SWBAccessIntTests: SweepBrightIntegrationTests {

    var token: dispatch_once_t = 0
    override func setUp() {
        super.setUp()

        dispatch_once(&token, {
            self.updateProperties()
        })
    }

    func runAccessUpdate(access: Access) {

        let newDetails = NSUUID().UUIDString
        access.details = newDetails

        let asyncExpectation = expectationWithDescription(self.name!)

        let locationService = SWBAccessService()
        //Property id and location id are the same
        locationService.syncAccess(access, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)

        XCTAssertEqual(access.details, newDetails)
        self.updateProperty(withId: access.id)
        XCTAssertEqual(access.details, newDetails)

    }

    func testUpdateAccess() {
        let realm = try! Realm()
        let access = realm.objects(Access).first!
        self.runAccessUpdate(Access(value: access))
    }

    func testUpdateProjectAccess() {
        let realm = try! Realm()
        let project = realm.objects(SWBProjectModel).first!
        self.runAccessUpdate(Access(value: project.property!.access!))
    }
}
