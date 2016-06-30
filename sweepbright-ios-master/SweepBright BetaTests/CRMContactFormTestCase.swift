//
//  CRMContactFormTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
class CRMContactFormTestCase: XCTestCase {
    var viewController: CRMAddContact!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "CRMAddContact", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("CRMAddContact") as! CRMAddContact
        _ = self.viewController.view
    }

    func testBindPhone() {
        let form = self.viewController.contactForm
        XCTAssert(form.phoneButton.hidden)
        form.phoneTextField.text = "8888"
        form.phoneTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.phoneButton.hidden)
    }
    func testBindEmail() {
        let form = self.viewController.contactForm
        XCTAssert(form.phoneButton.hidden)
        form.emailTextField.text = "info@madewithlove.be"
        form.emailTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.emailTextField.hidden)
    }

    func testFormIsValid() {
        let form = self.viewController.contactForm
        XCTAssertFalse(form.formIsValid)
        form.firstNameTextField.text = "First Name"
        form.firstNameTextField.sendActionsForControlEvents(.AllEditingEvents)
        form.surnameTextField.text = "Last name"
        form.surnameTextField.sendActionsForControlEvents(.AllEditingEvents)
        form.emailTextField.text = "info@madewithlove.be"
        form.emailTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssert(form.formIsValid)
        XCTAssert(self.viewController.addContactButton.enabled)
    }

    func testBind() {
        let form = self.viewController.contactForm
        form.contact = CRMContact()

        XCTAssertEqual(form.contact.first_name, "")
        form.firstNameTextField.text = "first name"
        form.firstNameTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertEqual(form.contact.first_name, form.firstNameTextField.text)

        XCTAssertEqual(form.contact.last_name, "")
        form.surnameTextField.text = "sur name"
        form.surnameTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertEqual(form.contact.last_name, form.surnameTextField.text)
    }

    func testSegmentControl() {
        let contact = CRMContact()
        self.viewController.contact = contact
        self.viewController.contact.contactType = .Vendor

        self.viewController.typeOfContactSegment.selectedSegmentIndex = 0
        self.viewController.typeOfContactSegment.sendActionsForControlEvents(.ValueChanged)
        XCTAssertEqual(self.viewController.contact.contactType, .Lead)

        self.viewController.typeOfContactSegment.selectedSegmentIndex = 1
        self.viewController.typeOfContactSegment.sendActionsForControlEvents(.ValueChanged)
        XCTAssertEqual(self.viewController.contact.contactType, .Vendor)
    }

    func testFormValidator() {
        let form = self.viewController.contactForm
        XCTAssertFalse(form.formIsValid)

        form.firstNameTextField.text = "Name"
        form.firstNameTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.formIsValid)

        form.surnameTextField.text = "Surname"
        form.surnameTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.formIsValid)

        form.phoneTextField.text = "9999-9999"
        form.phoneTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssert(form.formIsValid)

        form.phoneTextField.text = ""
        form.phoneTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.formIsValid)

        form.emailTextField.text = "validate@valide.com"
        form.emailTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssert(form.formIsValid)

        form.emailTextField.text = "invalidate@valide"
        form.emailTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssertFalse(form.formIsValid)
    }
}
