//
//  SWBCreatePropertyTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class SWBCreatePropertyTestCase: SweepBrightIntegrationTests {
    var realm: Realm!
    override func setUp() {
        super.setUp()
        self.realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
    }

    func testCreateHouseForSale() {
        let service = SWBPropertyService()
        XCTAssertEqual(self.realm.objects(SWBPropertyModel).count, 0)
        let asyncExpectation = expectationWithDescription(self.name!)

        service.createNewProperty(.House, negotiation: .ForSale, completionBlock: {
          asyncExpectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(10, handler: {
            _ in
            dispatch_async(dispatch_get_main_queue(), {
                let realm = try! Realm()
                XCTAssertEqual(realm.objects(SWBPropertyModel).count, 1)
            })
        })

        let property = self.realm.objects(SWBPropertyModel).first!.id

        let getObjectBlock = NSBlockOperation {
            SWBRoutes.getProperty(withId: property, completionHandler: {
                response in
                XCTAssertEqual(response.response!.statusCode, 200)
            })
        }
        self.runAsyncTest(getObjectBlock)
    }
}
