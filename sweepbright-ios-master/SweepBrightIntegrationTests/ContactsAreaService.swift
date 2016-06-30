//
//  ContactsAreaService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift

@testable import SweepBright
class ContactsAreaService: SweepBrightIntegrationTests, CRMContactService {
    var realm: Realm!

    override func setUp() {
        super.setUp()
        self.realm = try! Realm()
    }

    override func tearDown() {
        super.tearDown()
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }

    func insertContact() -> CRMContact {
        realm.add(contact: CRMContact(value: ["id": contactIDTest, "type": "lead"]))
        let contact = realm.objectForPrimaryKey(CRMContact.self, key: contactIDTest)!
        return CRMContact(value: contact)
    }

    private func runUpdateAreas(fromContact contact: CRMContact) {
        let asyncExpectation = self.expectationWithDescription(self.name!)
        self.expecting(statusCode: 200)
        self.updateAreas(fromContact: contact, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(15, handler: nil)
    }

    func testGetAreasFromContact() {
        let contact = self.insertContact()
        self.runUpdateAreas(fromContact: contact)
        debugPrint(realm.objects(CRMLocationPreference.self), contact.preferences!.locations)
        XCTAssert(contact.preferences!.locations.count > 0)
    }

    func testGetAreasFromContactMultipleTimes() {
        let contact = self.insertContact()
        self.runUpdateAreas(fromContact: contact)
        XCTAssert(contact.preferences!.locations.count > 0)
        self.runUpdateAreas(fromContact: contact)

        debugPrint(realm.objects(CRMLocationPreference.self), contact.preferences!.locations)
        XCTAssert(contact.preferences!.locations.count > 0)
    }
}
