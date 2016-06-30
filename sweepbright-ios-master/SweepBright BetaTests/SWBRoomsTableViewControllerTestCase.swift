//
//  SWBRoomsTableViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import CoreLocation
import Alamofire

@testable import SweepBright
class SWBRoomsTableViewControllerTestCase: XCTestCase {
    var viewController: SWBRoomsTableViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBRooms", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBRoomsTableViewController") as! SWBRoomsTableViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewDidLoad() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.tableView.rowHeight, UITableViewAutomaticDimension)
        XCTAssertEqual(self.viewController.beedroomsStepper.value, self.viewController.areaDatasource.areas.filter({ $0.structure == .Bedroom}).count)
        XCTAssertEqual(self.viewController.bathroomsStepper.value, self.viewController.areaDatasource.areas.filter({ $0.structure == .Bathroom}).count)

        XCTAssertEqual(self.viewController.wcStepper.value, self.viewController.areaDatasource.areas.filter({ $0.structure == .WC}).count)

        XCTAssert(self.viewController.compassCell.hidden)
    }

    func testToggleCompass() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        self.viewController.deviceOrientation = .N
        self.viewController.toggleCompass(self)
        XCTAssertFalse(self.viewController.compassCell.hidden)
    }


    func testGetOrientation() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(0)), SWBOrientation.N)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(45)), SWBOrientation.NE)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(90)), SWBOrientation.E)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(135)), SWBOrientation.SE)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(180)), SWBOrientation.S)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(225)), SWBOrientation.SW)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(270)), SWBOrientation.W)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(315)), SWBOrientation.NW)
        XCTAssertEqual(self.viewController.getOrientation(fromDegrees: CLLocationDirection(360)), SWBOrientation.N)
    }



    func testHeightForAreaTableView() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        let room = SWBPropertyRoomClass()
        property.room = room

        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.tableView(self.viewController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: self.viewController.areaTableViewSectionNumber)), 0)

        room.rooms.append(SWBRoomClass())
        self.viewController.refreshTables()

        XCTAssertEqual(self.viewController.tableView(self.viewController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: self.viewController.areaTableViewSectionNumber)), 44)

        XCTAssertNotEqual(self.viewController.tableView(self.viewController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: self.viewController.areaTableViewSectionNumber - 1)), 0)
    }
    func testUpdateSource() {
        let property = SWBPropertyModel(value:["title":"Property Model"])

        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertNotNil(SWBFloorPlanCollectionDatasource.getRoom())
        XCTAssertNotNil(SWBAreaTableViewDataSource.getRoom())
    }

    func testHighlightFloorCollection() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        let room = SWBPropertyRoomClass()
        property.room = room

        room.plans.append(SWBPlanClass())

        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertNil(self.viewController.selectedIndexPath)

        self.viewController.collectionView(self.viewController.floorPlanCollectionView, didHighlightItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertNotNil(self.viewController.selectedIndexPath)

    }

    func testPrepareForSegueWithoutSelectedIndexPath() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertNil(self.viewController.presentedViewController)
        self.viewController.performSegueWithIdentifier("showPlan", sender: self)
        XCTAssertNil(self.viewController.presentedViewController)
    }


    func testOrientationObservers() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        self.viewController.deviceOrientation = .S
        XCTAssertEqual(self.viewController.compassCell.orientation, SWBOrientation.S)
    }

    func testSetOrientation() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)

        let service = MockRoomService()
        self.viewController.roomService = service

        let _ = self.viewController.view

        self.viewController.compassCell.setOrientationButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssert(service.setOrientationExecuted)

    }

    func testUpdateFloor() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)

        let service = MockRoomService()
        self.viewController.roomService = service

        let _ = self.viewController.view

        XCTAssertFalse(service.setNumberOfFloorsExecuted)
        self.viewController.floorStepper.incrementValue(UIButton())
        XCTAssert(service.setNumberOfFloorsExecuted)
    }


    func testStructureService() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)

        let service = MockRoomService()
        self.viewController.roomService = service

        let _ = self.viewController.view


        XCTAssertEqual(unsafeAddressOf(service), unsafeAddressOf(self.viewController.beedroomsStepper.serviceDelegate.service as! MockRoomService) )
        XCTAssertEqual(unsafeAddressOf(service), unsafeAddressOf(self.viewController.bathroomsStepper.serviceDelegate.service as! MockRoomService))
        XCTAssertEqual(unsafeAddressOf(service), unsafeAddressOf(self.viewController.wcStepper.serviceDelegate.service as! MockRoomService))
    }



    func testUpdateStructures() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)

        let service = MockRoomService()
        self.viewController.roomService = service

        let _ = self.viewController.view

        XCTAssertFalse(service.setTotalOfRoomsExecuted)
        self.viewController.beedroomsStepper.incrementValue(UIButton())
        XCTAssert(service.setTotalOfRoomsExecuted)
    }

}
