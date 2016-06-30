//
//  SWBPriceIntTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class SWBPriceIntTests: SweepBrightIntegrationTests {
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
    func testUpdateProjectPrice() {
        let realm = try! Realm()
        let project = realm.objects(SWBProjectModel.self).first!
        self.runPriceTests(Price(value: project.property!.price!))
    }
    func testUpdatePrice() {
        let realm = try! Realm()
        let price = realm.objects(Price.self).first!
        self.runPriceTests(Price(value: price))
    }
    func runPriceTests(price: Price) {
        let service: SWBPriceService = SWBPriceService()
        let newCosts = NSUUID().UUIDString
        price.costs = newCosts
        let asyncExpectation = expectationWithDescription(self.name!)
        service.updatePrice(price, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)

        self.updateProperty(withId: price.id)
        XCTAssertEqual(price.costs, newCosts)
    }

}
