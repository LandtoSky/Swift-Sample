//
//  PropertyImageCollectionDatasourceTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/21/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class PropertyImageCollectionDatasourceTests: XCTestCase {

    class MockUICollectionView: UICollectionView {
        var reloadedData = false
        var reloadedItems = false
        override func reloadData() {
            //Nope
            reloadedData = true
        }
        override func reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
            //Sure ...
            reloadedItems = true
        }
    }

    var datasource: PropertyImageCollectionDatasource!

    override func setUp() {
        super.setUp()
        self.datasource = PropertyImageCollectionDatasource()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(100, 100)
        flowLayout.scrollDirection = .Horizontal
        return MockUICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)

    }

    func testHiddenWhenEmpty() {
        let collectionView = self.getCollectionView()
        collectionView.hidden = false

        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property

        XCTAssertEqual(self.datasource.numberOfSectionsInCollectionView(collectionView), self.datasource.sections.count)
        XCTAssert(collectionView.hidden)

        property.images.append(PropertyImage(data: "", visibility: .Private, image: UIImage()))

        XCTAssertEqual(self.datasource.numberOfSectionsInCollectionView(collectionView), self.datasource.sections.count)
        XCTAssertFalse(collectionView.hidden)
    }


    func testNumberOfItemsInSectionNeverZero() {
        //Each section must always have at least one cell to Drag and Drop works
        let collectionView = self.getCollectionView()

        //When we have an empty datasource
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property

        XCTAssertEqual(property.images.count, 0)
        //Then the datasource should return 1
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 1), 1)

        //When we add a new image
        property.images.append(PropertyImage(data: "", visibility: .Private, image: UIImage()))

        //Then the datasource has to return 1 still, because now there is data
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 1), 1)


        //When the datasource has more then one per section
        property.images.append(PropertyImage(data: "", visibility: .Private, image: UIImage()))

        //Then the datasource must to return the correct number os cells
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(self.datasource.collectionView(collectionView, numberOfItemsInSection: 1), 2)

    }

    func testSelectFirstItem() {
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))

        XCTAssertNil(self.datasource.getFilteredSection())
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertNotNil(self.datasource.getFilteredSection())
        XCTAssertEqual(self.datasource.getFilteredSection(), self.datasource.sections.first)
        XCTAssert(collectionView.reloadedData)
        XCTAssert(collectionView.reloadedItems)

    }

    func testDeselectItem() {
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 1, inSection: 0))

        collectionView.reloadedItems = false
        self.datasource.deselectedAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 1, inSection: 0))
        XCTAssert(collectionView.reloadedItems)
    }

    func testSelectItemTwice() {
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource
        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))

        XCTAssertNil(self.datasource.getFilteredSection())
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertNotNil(self.datasource.getFilteredSection())
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertNil(self.datasource.getFilteredSection())
    }

    func testGetImagesSelected() {
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource

        let propertyImage = PropertyImage(data: "", visibility: .Published, image: UIImage())
        property.images.append(propertyImage)

        XCTAssertEqual(self.datasource.getImagesSelected().count, 0)
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        let imagesSelected = self.datasource.getImagesSelected()
        XCTAssertEqual(imagesSelected.count, 1)
    }

    func testCanMoveCell() {
        //Remember on testNumberOfItemsInSectionNeverZero, the user cannot move a dummy cell
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource

        //Always false
        XCTAssertFalse(self.datasource.collectionView(collectionView, canMoveItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))

        property.images.append(PropertyImage(data: "", visibility: .Published, image: UIImage()))

        //Always false
        XCTAssertFalse(self.datasource.collectionView(collectionView, canMoveItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))
    }

    func testChangeSelectedsVisiblity() {
        let collectionView = self.getCollectionView() as! MockUICollectionView
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.datasource.property = property
        collectionView.dataSource = self.datasource
        property.addImage(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        property.addImage(PropertyImage(data: "", visibility: .Published, image: UIImage()))
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.datasource.selectAtIndexPath(collectionView, indexPath: NSIndexPath(forItem: 1, inSection: 0))

        XCTAssertEqual(property.getImagesByVisibility(.Published).count, 2)
        XCTAssertEqual(property.getImagesByVisibility(.Private).count, 0)

        self.datasource.changeSelectedsVisibility(collectionView)

        XCTAssertEqual(property.getImagesByVisibility(.Published).count, 0)
        XCTAssertEqual(property.getImagesByVisibility(.Private).count, 2)

    }

}
