//
//  ContactAddressTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
let contactIDTest = "aee671b3-64ee-4162-bcf6-2faaa8303248"
class ContactAddressTestCase: SweepBrightIntegrationTests, CRMContactAddressService {
    var address: CRMContactAddress!
    var realm: Realm!

    override func setUp() {
        super.setUp()

        let contact = CRMContact(value: ["id": contactIDTest])
        self.address = CRMContactAddress(value: ["id": contactIDTest, "street": "Evergreen Terrace", "city": "Springfield", "nr": "742", "add": "add", "postcode": "", "contact": contact])
        contact.address = self.address
        self.realm = try! Realm()
        self.realm.saveOrUpdate(contact: contact)
    }

    func testSyncContactAddress() {
        let newAddress = "New Address \(NSUUID().UUIDString)"
        let copiedAddress = CRMContactAddress(value: self.address)
        copiedAddress.street = newAddress

        let asyncExpectation = expectationWithDescription(self.name!)
        self.update(address: copiedAddress, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)
        self.address = realm.objectForPrimaryKey(CRMContactAddress.self, key: copiedAddress.id)
        XCTAssertEqual(self.address.street!, newAddress)
    }
}
