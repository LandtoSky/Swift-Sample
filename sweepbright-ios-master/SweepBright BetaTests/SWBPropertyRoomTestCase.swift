//
//  SWBPropertyRoomTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/16/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
import SwiftyJSON

@testable import SweepBright

class SWBPropertyRoomTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONDesealizerOrientationWithGarden() {
        let orientation = JSON(["orientation": ["garden": "N"], "structure": ["floors": 2]])
        let room = SWBPropertyRoomClass()
        room.initWithJSON(orientation)

        XCTAssertEqual(room.gardenOrientation!.orientation, .N)
        XCTAssertEqual(room.floors, 2)

        XCTAssertNil(room.terraceOrientation!.orientation)
    }

    func testJSONDesealizerOrientationWithTerrace() {
        let orientation = JSON(["orientation":["terrace":"N"]])
        let room = SWBPropertyRoomClass()
        room.initWithJSON(orientation)

        XCTAssertEqual(room.terraceOrientation!.orientation, .N)

        XCTAssertNil(room.gardenOrientation!.orientation)
    }


    func testSetAGardenOrientation() {
        let room = SWBPropertyRoomClass()
        room.gardenOrientation = SWBOrientationModel(_orientation:"S")
        XCTAssertEqual(room.gardenLocation, "S")
    }


    func testSetATerraceOrientation() {
        let room = SWBPropertyRoomClass()
        room.terraceOrientation = SWBOrientationModel(_orientation:"S")
        XCTAssertEqual(room.terraceLocation, "S")
    }

    func testGetStrucuture() {
        let room = SWBRoomClass()
        room.structure = .WC
        XCTAssertEqual(room.type, "wc")
    }

    func testGetUnits() {
        let room = SWBRoomClass()
        room.units = .Meter
        XCTAssertEqual(room.unit, "sq_m")

        room.units = .Foot
        XCTAssertEqual(room.unit, "sq_ft")

        room.unit = "sq_m"
        XCTAssertEqual(room.units, SWBUnits.Meter)
    }

    func testAddAmenityRoom() {
        let room = SWBPropertyRoomClass()
        room.amenities.append(SWBAmenityModel(value: ["_amenity": SWBAmenity.Pool.rawValue]))
        let realm = try! Realm()
        try! realm.write({
            realm.add(room)
        })

        XCTAssertEqual(room.amenities.count, 1)
        XCTAssertEqual(room.amenities.filter({$0.amenity == .Pool}).count, 1)

        room.addOrRemoveAmenity(.Garden)
        XCTAssertEqual(room.amenities.count, 2)
        XCTAssertEqual(room.amenities.filter({$0.amenity == .Pool}).count, 1)
        XCTAssertEqual(room.amenities.filter({$0.amenity == .Garden}).count, 1)

        room.addOrRemoveAmenity(.Garden)
        XCTAssertEqual(room.amenities.count, 1)
        XCTAssertEqual(room.amenities.filter({$0.amenity == .Pool}).count, 1)
        XCTAssertEqual(room.amenities.filter({$0.amenity == .Garden}).count, 0)
    }
}
