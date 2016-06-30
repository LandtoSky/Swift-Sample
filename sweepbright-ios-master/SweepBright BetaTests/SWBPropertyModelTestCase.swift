//
//  SWBPropertyModelTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/17/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import SweepBright
class SWBPropertyModelTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDeserializer() {
        let property = SWBPropertyModel()
        let jsonDictionary = [
            "data":[
                "id": "fakeId",
                "type": "apartment",
                "negotiation": "sale",
                "attributes": [],
                "created_at": "2016-02-08T19:10:36+00:00",
                "updated_at": "2016-02-17T14:51:21+00:00"
            ]
        ]

        let json = JSON(jsonDictionary)

        property.initWithJSON(json["data"])

        XCTAssertEqual(property.id, "fakeid")
        XCTAssertEqual(property.negotiation, "sale")
        XCTAssertEqual(property.propertyType, "apartment")
    }

    func testDeserializeAmenities() {
        let property = SWBPropertyModel()
        let jsonDictionary = [
            "data":[
                "id": "fakeId",
                "type": "apartment",
                "negotiation": "sale",
                "attributes": [
                    "amenities":[
                        "pool"
                    ]
                ],
                "created_at": "2016-02-08T19:10:36+00:00",
                "updated_at": "2016-02-17T14:51:21+00:00"
            ]
        ]

        let json = JSON(jsonDictionary)

        property.initWithJSON(json["data"])
        XCTAssertEqual(property.room?.amenities.count, 1)
        XCTAssertEqual(property.room!.amenities.filter({$0.amenity == .Pool}).count, 1)
    }

}
