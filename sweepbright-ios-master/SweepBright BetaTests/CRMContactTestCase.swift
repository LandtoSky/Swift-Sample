//
//  CRMContactTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift

@testable import SweepBright
class CRMContactTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    func testFullName() {
        let contact = CRMContact(value: ["first_name": "Harry", "last_name": "Potter"])
        XCTAssertEqual(contact.fullName, "Harry Potter")
    }

    func testAbbreviation() {
        let contact = CRMContact(value: ["first_name": "Harry", "last_name": "Potter"])
        XCTAssertEqual(contact.abbreviation, "HP")
    }

    func testAbbreviationOneWord() {
        let contact = CRMContact(value: ["first_name": "Harry"])
        XCTAssertEqual(contact.abbreviation, "H")
    }

    func testAbbreviationSeveralWords() {
        let contact = CRMContact(value: ["first_name": "One Two", "last_name": "Four"])
        XCTAssertEqual(contact.abbreviation, "OT")
    }

    func testAbbreviationWithRandomWhitespaces() {
        //The full name will be `One Two  Four `
        let contact = CRMContact(value: ["first_name": "One Two ", "last_name": "Four "])
        XCTAssertEqual(contact.abbreviation, "OT")
    }
}
