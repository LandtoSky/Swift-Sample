//
//  SWBPropertySettingsTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright

class SWBPropertySettingsTestCase: XCTestCase {

    var viewController: SWBPropertySettingsTableViewController!
    var service: MockSettingsService!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SWBSettings", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBPropertySettingsTableViewController") as! SWBPropertySettingsTableViewController
        self.service = MockSettingsService()
        self.viewController.service = self.service
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    func testBindData() {
        let property = SWBPropertyModel()
        property.settings?.allowed = false
        property.settings?.from = nil
        property.settings?.notes = "Notes"
        property.settings?.startDate = NSDate()
        property.settings?.endDate = NSDate()
        property.settings?.negotiator = "Negotiator"
        property.settings?.reference = "Reference"
        property.settings?.statusProperty = .Bid

        self.viewController.property = property

        _ = self.viewController.view
        XCTAssertFalse(self.viewController.advertisementAllowedSwitch.on)
        XCTAssertEqual(self.viewController.advertisementAvailableFromDate.titleLabel?.text, self.viewController.advertisementAvailableFromDate.defaultText)
        XCTAssertEqual(self.viewController.mandateStartDate.date, property.settings?.startDate)
        XCTAssertEqual(self.viewController.mandateEndDate.date, property.settings?.endDate)
        XCTAssertEqual(self.viewController.notesTextView.text, property.settings?.notes)
        XCTAssertEqual(self.viewController.officeReference.text, property.settings?.reference)
        XCTAssertEqual(self.viewController.officeNegotiator.text, property.settings?.negotiator)
        XCTAssertEqual(self.viewController.stateOfSale.stateSale, SWBPropertyStatusSettings.Bid) //Reference to .Bid

        XCTAssertFalse(self.service.fromSynced)
        XCTAssertFalse(self.service.allowedSynced)
    }

    func testStateOfSale() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.stateSynced)
        self.viewController.stateOfSale.stateSale = .Closed
        XCTAssert(self.service.stateSynced)
    }

    func testStateOfSaleLabelsForSale() {
        let property = SWBPropertyModel()
        property.status = .ForSale
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.viewController.stateOfSaleForSaleLabels.hidden)
        XCTAssert(self.viewController.stateOfSaleLetLabels.hidden)
    }
    func testStateOfSaleLabelsToLet() {
        let property = SWBPropertyModel()
        property.status = .ToLet
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssert(self.viewController.stateOfSaleForSaleLabels.hidden)
        XCTAssertFalse(self.viewController.stateOfSaleLetLabels.hidden)
    }
    func testServiceAdvertisementFrom() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.fromSynced)
        self.viewController.advertisementAvailableFromDate.date = NSDate()
        XCTAssert(self.service.fromSynced)
    }
    func testServiceOfficeNegotiator() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.negotiatorSynced)
        self.viewController.officeNegotiator.text = "New Value"
        self.viewController.officeNegotiator.sendActionsForControlEvents(.EditingDidEnd)
        XCTAssert(self.service.negotiatorSynced)
    }
    func testServiceOfficeReference() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.referenceSynced)
        self.viewController.officeReference.text = "New Value"
        self.viewController.officeReference.sendActionsForControlEvents(.EditingDidEnd)
        XCTAssert(self.service.referenceSynced)
    }
    func testServiceAdvertisementAllowed() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.allowedSynced)
        self.viewController.advertisementAllowedSwitch.setOn(false)
        XCTAssert(self.service.allowedSynced)
    }

    func testServiceMandateStart() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.mandateStartDateSynced)
        self.viewController.mandateStartDate.date = NSDate()
        XCTAssert(self.service.mandateStartDateSynced)
    }
    func testServiceMandateEnd() {
        let property = SWBPropertyModel()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.mandateEndDateSynced)
        self.viewController.mandateEndDate.date = NSDate()
        XCTAssert(self.service.mandateEndDateSynced)
    }
    func testMandateEndDateValidation() {
        let property = SWBPropertyModel()
        property.settings?.startDate = NSDate()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.mandateEndDateSynced)
        self.viewController.mandateEndDate.date = NSDate(timeIntervalSince1970: 0) // endDate will be 01/01/1970
        XCTAssertFalse(self.service.mandateEndDateSynced)
        XCTAssertNil(self.viewController.mandateEndDate.date)
    }

    func testMandateStartDateValidation() {
        let property = SWBPropertyModel()
        property.settings?.endDate = NSDate()
        self.viewController.property = property
        _ = self.viewController.view

        XCTAssertFalse(self.service.mandateStartDateSynced)
        self.viewController.mandateStartDate.date = NSDate().dateByAddingTimeInterval(3600)
        XCTAssertFalse(self.service.mandateStartDateSynced)
        XCTAssertNil(self.viewController.mandateStartDate.date)
    }
}
