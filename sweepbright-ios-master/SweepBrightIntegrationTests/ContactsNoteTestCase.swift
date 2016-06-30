//
//  ContactsNoteTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift

@testable import SweepBright
class ContactsNoteTestCase: SweepBrightIntegrationTests, CRMContactNotesService {

    var contact: CRMContact!

    override func setUp() {
        super.setUp()
        let email = "integration+testing@mwl.be"
        self.contact = CRMContact(value: ["id": contactIDTest, "email": email, "first_name": NSUUID().UUIDString, "last_name": NSUUID().UUIDString])
        let realm = try! Realm()
        realm.add(contact: contact)
    }
    override func tearDown() {
        super.tearDown()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    func testUpdateServiceContact() {
        let uuid = NSUUID().UUIDString
        let newNotes = "This is a test : \(uuid)"
        XCTAssertNil(self.contact.note)

        let asyncExpectation = expectationWithDescription(self.name!)
        self.updateNotes(newNotes, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertEqual(self.contact.note, newNotes)
    }
}
