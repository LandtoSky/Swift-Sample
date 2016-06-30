//
//  PropertyImagesViewControllerTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/18/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import UIKit
@testable import SweepBright

class PropertyImagesViewControllerTests: XCTestCase {
    var viewController: PropertyImagesViewController!

    class WasCalledDatasource: PropertyImageCollectionDatasource {
        var changedSelectedsVisibility = false

        func changeSelectedsVisibility(collectionView: UICollectionView) {
            self.changedSelectedsVisibility = true
        }
    }

    class MockDatasource: PropertyImageCollectionDatasource {
        var selected = false

        func selectAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
            super.selectAtIndexPath(collectionView, indexPath: indexPath)
            self.selected = true
        }
    }
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SWBImage", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("PropertyImagesViewController") as! PropertyImagesViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStateDefault() {
        let _ = self.viewController.view
        self.viewController.state = .Default
        XCTAssertEqual(self.viewController.state, State.Default)
        XCTAssertFalse(self.viewController.selectMultipleMenuAppears)
    }

    func testStateSelect() {
        let _ = self.viewController.view
        self.viewController.state = .Selecting
        XCTAssert(self.viewController.selectMultipleMenuAppears)
        XCTAssertEqual(self.viewController.navigationItem.rightBarButtonItem, self.viewController.doneButton)
        XCTAssert(self.viewController.makeAsView.hidden)
        XCTAssert(self.viewController.deleteView.hidden)
    }

    func testSelectingMultiples() {
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.state, State.Default)
        self.viewController.selectMultiples(self)
        XCTAssertEqual(self.viewController.state, State.Selecting)

    }

    func testSelectedMultiples() {
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.state, State.Default)
        self.viewController.state = .Selected
        XCTAssertFalse(self.viewController.makeAsButton.hidden)
        XCTAssertFalse(self.viewController.deleteButton.hidden)
    }

    func testDoneState() {
        let _ = self.viewController.view
        self.viewController.state = .Selecting
        self.viewController.doneSelectMultiple(self)

        XCTAssertEqual(self.viewController.state, State.Default)
    }


    func testBackInformationDelegate() {
        let _ = self.viewController.view
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.property = property
        XCTAssertEqual(self.viewController.property.images.count, 0)
        (self.viewController as BackInformationDelegate).returnInformation(self.viewController, info: [SWBAvyBackDelegate:UIImage()])
        XCTAssertEqual(self.viewController.property.images.count, 1)
    }

    func testBackInformationDelegateWithoutImage() {
        let _ = self.viewController.view
        self.viewController.property = SWBPropertyModel(value:["title":"Property Model"])
        XCTAssertEqual(self.viewController.property.images.count, 0)
        (self.viewController as BackInformationDelegate).returnInformation(self.viewController, info: [:])
        XCTAssertEqual(self.viewController.property.images.count, 0)
    }

    func testPropertyBinding() {
        let _ = self.viewController.view
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.property = property


        let newProperty =  SWBPropertyModel(value:["title":"Property Model"])

        self.viewController.property = newProperty

        XCTAssertEqual((self.viewController.datasource as! PropertyImageCollectionDatasource).property.address, newProperty.address)
    }

    func testConfirmExclusionImagesSelecteds() {
        let _ = self.viewController.view
        let datasource = WasCalledDatasource()
        self.viewController.datasource = datasource
        self.viewController.collectionView.dataSource = self.viewController.datasource

        let property =  SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.property = property

        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        self.viewController.datasource.selectAtIndexPath(self.viewController.collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.viewController.datasource.selectAtIndexPath(self.viewController.collectionView, indexPath: NSIndexPath(forItem: 1, inSection: 0))

        self.viewController.confirmExclusionImagesSelecteds(self)

        XCTAssertEqual(property.images.count, 0)
    }

    func testDidSelectItemAtIndexPath() {
        let _ = self.viewController.view
        let datasource = MockDatasource()
        self.viewController.datasource = datasource
        self.viewController.collectionView.dataSource = self.viewController.datasource

        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        self.viewController.property = property

        self.viewController.state = .Default
        self.viewController.collectionView(self.viewController.collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.viewController.dismissViewControllerAnimated(false, completion: nil)

        XCTAssert(self.viewController.state == .Default)
        XCTAssertFalse(datasource.selected)
    }

    func testDidSelectDummyItem() {
        let _ = self.viewController.view
        let datasource = MockDatasource()
        self.viewController.datasource = datasource
        self.viewController.collectionView.dataSource = self.viewController.datasource

        let property =  SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.property = property

        self.viewController.state = .Default
        self.viewController.collectionView(self.viewController.collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))

        XCTAssertNil(self.viewController.presentedViewController)
        XCTAssert(self.viewController.state == .Default)
        XCTAssertFalse(datasource.selected)
    }
}
