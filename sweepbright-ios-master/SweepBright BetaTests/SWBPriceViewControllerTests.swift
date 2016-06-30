//
//  SWBPriceViewControllerTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright

class SWBPriceViewControllerTests: XCTestCase {

    class MockSWBPriceService: SWBPriceServiceProtocol {
        var queue: NSOperationQueue! = NSOperationQueue()
        var priceUpdated: Bool = false
        func updatePrice(price: Price, completionBlock: (() -> ())?) {
            self.priceUpdated = true
        }
    }
    var priceService: MockSWBPriceService!
    var viewController: SWBPriceTableViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "SWBPrice", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBPriceTableViewController") as! SWBPriceTableViewController

        self.priceService = MockSWBPriceService()
        self.viewController.priceService = self.priceService
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPopulateForm() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.price = Price()
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual(property.price!.costs, self.viewController.costsTextView.text)
        XCTAssertEqual(property.price!.taxes, self.viewController.taxesTextView.text)
    }

    func testToLetPublishedLabel() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.status = .ToLet
        property.price = Price()
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual("Published Rent", self.viewController.publishedLabel.text)
    }


    func testForSalePublishedLabel() {

        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.price = Price()
        property.status = .ForSale
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertEqual("Published Price", self.viewController.publishedLabel.text)
    }

    func testUpdateData() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.price = Price()
        property.status = .ForSale
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertFalse(self.priceService.priceUpdated)
        self.viewController.updateData()
        XCTAssert(self.priceService.priceUpdated)
    }

    func testDefaultPriceValue() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.propertyDependent(property)
        let _ = self.viewController.view
        //It shall not crash
        XCTAssert(true)
    }
}
