//
//  SWBPropertiesTest.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright

class SWBPropertiesTest: SweepBrightIntegrationTests {
    var realm: Realm!
    let service = SWBPropertyService()

    override func setUp() {
        super.setUp()

        self.realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
    }

    func testUpdateListofProperties() {

        let listOfProperties = realm.objects(SWBPropertyModel.self)

        XCTAssertEqual(listOfProperties.count, 0)
        self.updateProperties()
        XCTAssertNotEqual(listOfProperties.count, 0)
    }

    func testUpdateListofPropertiesMultipleTimes() {
        //https://github.com/madewithlove/sweepbright-ios/issues/233
        self.updateProperties()
        self.updateProperties()

        let totalOfProperties = realm.objects(SWBPropertyModel.self).count
        XCTAssertEqual(totalOfProperties, realm.objects(SWBFeaturesModel.self).count)
        XCTAssertEqual(totalOfProperties, realm.objects(SWBPropertyLocationModel.self).count)
        XCTAssertEqual(totalOfProperties, realm.objects(SWBLegalDocsModel.self).count)
        XCTAssertEqual(totalOfProperties, realm.objects(SWBPropertyRoomClass.self).count)
        XCTAssertEqual(totalOfProperties, realm.objects(Access.self).count)
        XCTAssertEqual(totalOfProperties, realm.objects(Price.self).count)
    }
}
