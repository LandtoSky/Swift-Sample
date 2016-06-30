//
//  SWBFloorPlanCollectionDatasourceTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class SWBFloorPlanCollectionDatasourceTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSharedData() {
        let datasource = SWBFloorPlanCollectionDatasource()
        let datasource2 = SWBFloorPlanCollectionDatasource()

        let property = SWBPropertyModel(value:["title":"Property Model"])
        let room = SWBPropertyRoomClass()
        property.room = room

        room.plans.append(SWBPlanClass())

        SWBFloorPlanCollectionDatasource.setRoom(room)
        XCTAssertEqual(1, room.plans.count)
        XCTAssertEqual(datasource.plans.count, room.plans.count)
        XCTAssertEqual(datasource2.plans.count, room.plans.count)

        SWBFloorPlanCollectionDatasource.addPlan(SWBPlanClass())
        XCTAssertEqual(2, room.plans.count)
        XCTAssertEqual(datasource.plans.count, room.plans.count)
        XCTAssertEqual(datasource2.plans.count, room.plans.count)
    }

}
