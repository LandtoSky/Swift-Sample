//
//  SWBAddPlanViewControllerTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright

class SWBAddPlanViewControllerTestCase: XCTestCase {
    var viewController: SWBAddPlanViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBRooms", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBAddPlanViewController") as! SWBAddPlanViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewDidLoad() {
        let _ = self.viewController.view
        XCTAssert(self.viewController.planImageView.hidden)
    }

    func testUnhidePlanImage() {
        self.viewController.plan = SWBPlanClass(surfaces:[SWBSurfaceClass(position: CGPoint.zero)], image: UIImage())
        let _ = self.viewController.view
        XCTAssertFalse(self.viewController.planImageView.hidden)
    }


    func testUnhidePlanImageOnBackinformation() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        let room = SWBPropertyRoomClass()
        property.room = room

        SWBFloorPlanCollectionDatasource.setRoom(room)
        let _ = self.viewController.view
        XCTAssert(self.viewController.planImageView.hidden)
        self.viewController.imagePickerController(self.viewController.imagePicker, didFinishPickingMediaWithInfo: [UIImagePickerControllerOriginalImage:UIImage()])
        XCTAssertFalse(self.viewController.planImageView.hidden)
        XCTAssertEqual(self.viewController.planImageView.image, self.viewController.plan.image)
    }

    func testRenderSurfaces() {
        self.viewController.imagePlan = UIImage()
        let _ = self.viewController.view

        let totalOfSurfaces = self.viewController.addPlanView.surfaceViews.count
        self.viewController.imagePlan = UIImage()
        XCTAssertEqual(totalOfSurfaces, self.viewController.addPlanView.surfaceViews.count)

    }

    func testAddSurface() {
        self.viewController.imagePlan = UIImage()
        let _ = self.viewController.view

        let totalOfSurfaces = self.viewController.addPlanView.surfaceViews.count

        self.viewController.touchesBegan([UITouch()], withEvent: .None)
        XCTAssertEqual(totalOfSurfaces, self.viewController.addPlanView.surfaceViews.count)
    }

    func testAddSurfaceWithSelectedRoom() {
        self.viewController.plan = SWBPlanClass()
        let _ = self.viewController.view
        self.viewController.selectedRoom = SWBRoomClass(value:["type": "bedroom", "area": "0.0"])

        let totalOfSurfaces = self.viewController.addPlanView.surfaceViews.count

        self.viewController.touchesBegan([UITouch()], withEvent: .None)
        XCTAssertEqual(totalOfSurfaces+1, self.viewController.addPlanView.surfaceViews.count)
        XCTAssertNil(self.viewController.selectedRoom)
        XCTAssertEqual(self.viewController.plan.surfaces.count, self.viewController.addPlanView.surfaceViews.count)
    }

    func testAddSurfaceButtonWhenSelectedRoom() {
        self.viewController.imagePlan = UIImage()
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.addSurfaceButton.hidden)
        self.viewController.selectedRoom = SWBRoomClass(value: ["type": "bedroom", "area": "0.0"])
        XCTAssert(self.viewController.addSurfaceButton.hidden)
    }


    func testAddSurfaceAfterSelectAnImage() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        let room = SWBPropertyRoomClass()
        property.room = room

        SWBFloorPlanCollectionDatasource.setRoom(room)
        let _ = self.viewController.view

        XCTAssertEqual(SWBFloorPlanCollectionDatasource.getRoom().plans.count, 0)
        XCTAssertEqual(self.viewController.plan.surfaces.count, 0)

        self.viewController.imagePickerController(self.viewController.imagePicker, didFinishPickingMediaWithInfo: [UIImagePickerControllerOriginalImage:UIImage()])

        XCTAssertEqual(SWBFloorPlanCollectionDatasource.getRoom().plans.count, 1)
        XCTAssertEqual(unsafeAddressOf(SWBFloorPlanCollectionDatasource.getRoom().plans.first!), unsafeAddressOf(self.viewController.plan))

        self.viewController.selectedRoom = SWBRoomClass(value: ["type": "bedroom", "area": "0.0"])
        self.viewController.touchesBegan([UITouch()], withEvent: .None)

    }


}
