//
//  SWBAmenitiesCollectionViewTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/15/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright

class SWBAmenitiesCollectionViewTestCase: XCTestCase {

    var service: MockRoomServiceDelegate!
    var collectionView: SWBAmenitiesCollectionView!

    override func setUp() {
        super.setUp()

        self.service = MockRoomServiceDelegate()
        let storyboard = UIStoryboard(name: "SWBRooms", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SWBRoomsTableViewController") as! SWBRoomsTableViewController
        viewController.property = self.service.serviceProperty
        let _ = viewController.view
        self.collectionView = viewController.amenitiesCollectionView
    }

    func testAmenitiesAvailable() {
        collectionView.serviceDelegate = self.service
        XCTAssertEqual(collectionView.amenities, self.service.serviceProperty.amenitiesAvailable)
    }

    func testPopulatingCollection() {
        let poolIndex = collectionView.amenities.indexOf(.Pool)
        collectionView.serviceDelegate = self.service
        collectionView.reloadData()

        var cell = collectionView.collectionView(self.collectionView, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: poolIndex!)) as! SWBAmenityCollectionViewCell
        XCTAssertFalse(cell.selectedSwitch.on)

        collectionView.amenitiesEnabled.append(.Pool)
        cell = collectionView.collectionView(self.collectionView, cellForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: poolIndex!)) as! SWBAmenityCollectionViewCell
        XCTAssert(cell.selectedSwitch.on)
    }
}
