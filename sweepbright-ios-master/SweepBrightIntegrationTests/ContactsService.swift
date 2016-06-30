//
//  ContactsService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright
class ContactsServiceTestCase: SweepBrightIntegrationTests, CRMContactService {
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

    func testUpdateContact() {
        //Given
        let copiedContact = self.insertContact()

        //When
        let asyncExpectation = expectationWithDescription(self.name!)
        let newFirstName = NSUUID().UUIDString
        let lastName = NSUUID().UUIDString
        let email = "integration+testing@mwl.be"
        copiedContact.first_name = newFirstName
        copiedContact.last_name = lastName
        copiedContact.email = email

        self.expecting(statusCode: 200)
        self.saveContactInfo(copiedContact, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)

        //Then
        let contact = realm.objectForPrimaryKey(CRMContact.self, key: contactIDTest)!
        XCTAssertEqual(contact.first_name, newFirstName)
        XCTAssertEqual(contact.last_name, lastName)
        XCTAssertEqual(contact.email, email)
    }

    func testUpdateListOfContacts() {
        let asyncExpectation = expectationWithDescription(self.name!)

        self.expecting(statusCode: 200)
        self.updateContactsList({
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)
        let contactsCount = realm.getAllContacts().count
        XCTAssert(contactsCount > 0)

        let addressesCount = realm.objects(CRMContactAddress.self).count
        XCTAssertEqual(contactsCount, addressesCount)

        let preferencesCount = realm.objects(CRMContactPreferences.self).count
        XCTAssertEqual(preferencesCount, realm.getLeads().count)
    }

    func testArchiveContact() {
        //Given
        let asyncExpectation = expectationWithDescription(self.name!)
        var contact = self.insertContact()
        XCTAssertFalse(contact.is_archived)

        self.expecting(statusCode: 200)
        //When
        self.changeArchiveStatus(fromContact: contact, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)
        contact = realm.objectForPrimaryKey(CRMContact.self, key: contactIDTest)!
        //Then
        XCTAssert(contact.is_archived)
    }

    func testAddLead() {
        let contact = CRMContact(value: ["type": "lead", "first_name": "First name", "last_name": "Last name", "email": "integration+testing@mwl.be"])

        self.expecting(statusCode: 201)
        self.addContact(contact)
    }

    func testAddVendor() {
        let contact = CRMContact(value: ["type": "vendor", "first_name": "First name", "last_name": "Last name", "email": "integration+testing@mwl.be"])
        self.expecting(statusCode: 201)
        self.addContact(contact)
    }

    private func addContact(contact: CRMContact) {

        XCTAssertNil(contact.realm)
        let asyncExpectation = expectationWithDescription(self.name!)
        self.addNewContact(contact, completionBlock: {
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertNotNil(contact.realm)
    }

    func testDispatchNotificationAfterAddingAContact() {
        let contact = CRMContact(value: ["first_name": "One Two ", "last_name": "Four "])
        var dispatched = false

        NSNotificationCenter.defaultCenter().rac_addObserverForName(CRMNewContactAddedNotification, object: nil).subscribeNext({_ in dispatched = true })

        XCTAssertFalse(dispatched)
        self.addNewContact(contact)
        XCTAssert(dispatched)
    }
}
