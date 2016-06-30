//
//  SWBLegalDocsIntTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/10/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import Foundation
import RealmSwift
import Alamofire

@testable import SweepBright
class SWBLegalDocsIntTests: SweepBrightIntegrationTests {
    var property: SWBPropertyModel!
    var project: SWBPropertyModel!
    var docsService: SWBLegalDocsService!
    var realm: Realm!

    override func setUp() {
        super.setUp()
        self.realm = try! Realm()
        self.docsService = SWBLegalDocsService()
    }

    override func tearDown() {
        super.tearDown()
        try! self.realm.write({
            realm.deleteAll()
        })
    }

    func insertLetProject() {

        let projectID = "12fae0e5-3a82-4e6e-b8ac-3cd522f68de8"
        self.project = SWBPropertyModel(value: ["id": projectID, "negotiation": "let", "propertyType": "house"])
        self.project.legalDocs?.id = projectID
        self.project.project = SWBProjectModel(value: ["project": projectID, "property": project])

        try! realm.write({
            realm.add(project, update: true)
        })
    }

    func insertProject() {
        let projectID = "3e97a867-7cb4-476b-937d-65363bf9a8d7"
        self.project = SWBPropertyModel(value: ["id": projectID, "negotiation": "sale", "propertyType": "house"])
        self.project.legalDocs?.id = projectID
        self.project.project = SWBProjectModel(value: ["project": projectID, "property": project])

        try! realm.write({
            realm.add(project, update: true)
        })
    }

    func insertLetProperty() {
        let propertyID = "b0ea9882-e0a7-42ba-9fe6-99062453e2a8"

        self.property = SWBPropertyModel(value: ["id": propertyID, "negotiation": "let", "propertyType": "house"])
        self.property.legalDocs?.id = propertyID

        try! realm.write({
            realm.add(property, update: true)
        })
    }

    func insertProperty() {
        let propertyID = "6a864e90-0dab-432a-9eab-aa5f14d10a35"
        self.property = SWBPropertyModel(value: ["id": propertyID, "negotiation": "sale", "propertyType": "house"])
        self.property.legalDocs?.id = propertyID

        try! realm.write({
            realm.add(property, update: true)
        })
    }

    // - MARK: Mandate dates
    func testMandateDates() {
        self.insertLetProperty()
        self.runTenantDates(self.property.legalDocs!)
    }

    func testMandateDatesInProject() {
        self.insertLetProject()
        self.runTenantDates(self.project.legalDocs!)
    }

    private func runTenantDates(legalDocs: SWBLegalDocsModel) {
        let asyncExpectation = expectationWithDescription(self.name!)
        self.docsService.completionHandler = {
            response in
            XCTAssertNotNil(response.response)
            XCTAssertEqual((response.response!.statusCode), 200)
            asyncExpectation.fulfill()
        }
        let newDate = NSDate()
        self.docsService.syncTenantContractDate(legalDocs, path: .StartDate, value: newDate)
        self.waitForExpectationsWithTimeout(30, handler: nil)
        let newDateAsStr = Formatter.jsonDateFormatter.stringFromDate(newDate)
        let propertyDateAsStr = Formatter.jsonDateFormatter.stringFromDate(legalDocs.startDate!)
        XCTAssertEqual(propertyDateAsStr, newDateAsStr)
    }

    // - MARK: Notes
    func testChangeNotesFromProperty() {
        self.insertProperty()
        self.runChangeNotesFor(property: self.property)
    }

    func testChangeNotesFromProject() {
        self.insertProject()
        self.runChangeNotesFor(property: self.project)
    }

    private func runChangeNotesFor(property property: SWBPropertyModel) {
        let legalDocs = SWBLegalDocsModel(value: property.legalDocs!)
        let newNotes = NSUUID().UUIDString
        legalDocs.notes = newNotes

        let asyncExpectation = expectationWithDescription(self.name!)
        self.docsService.completionHandler = {
            response in
            XCTAssertNotNil(response.response)
            XCTAssertEqual((response.response!.statusCode), 200)
            asyncExpectation.fulfill()
        }
        self.docsService.syncLegalDocs(legalDocs)
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        XCTAssertEqual(property.legalDocs?.notes, newNotes)
    }
}
