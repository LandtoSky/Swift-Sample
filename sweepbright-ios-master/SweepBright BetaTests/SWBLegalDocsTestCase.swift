//
//  SWBLegalDocsTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class SWBLegalDocsTestCase: XCTestCase {

    var viewController: SWBLegalDocumentsTableViewController!
    var service = MockSWBLegalDocsService()
    var property: SWBProperty!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SWBLegalDocs", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBLegalDocumentsTableViewController") as! SWBLegalDocumentsTableViewController
        self.viewController.service = self.service
        self.property = self.setProperty()
        UIApplication.sharedApplication().keyWindow!.rootViewController?.presentViewController(self.viewController, animated: false, completion: nil)
        viewController.beginAppearanceTransition(true, animated: false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func setProperty() -> SWBPropertyModel {
        let property = SWBPropertyModel()
        property.legalDocs = SWBLegalDocsModel(value:["notes":"SWBLegalDocsModel"])

        self.viewController.propertyDependent(property)
        return property
    }

    func testCalculateSection() {
        self.viewController.property.status = .ForSale
        self.viewController.calculateSection()
        XCTAssertEqual(self.viewController.sections.map({$0.title!}), ["INTERNAL LEGAL NOTES", "", "DOCUMENTS", ""])

        self.viewController.property.status = .ToLet
        self.viewController.calculateSection()
        XCTAssertEqual(self.viewController.sections.map({$0.title!}), ["TENANT CONTRACT", "", "DOCUMENTS", ""])
    }
}
