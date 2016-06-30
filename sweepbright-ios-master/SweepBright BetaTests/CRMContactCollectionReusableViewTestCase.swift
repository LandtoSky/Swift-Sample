//
//  CRMContactCollectionReusableViewTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import ReactiveCocoa

@testable import SweepBright
class CRMContactCollectionReusableViewTestCase: XCTestCase {

    func testContactBind() {
        let view = CRMContactCollectionReusableView(frame: CGRect.zero)
        view.awakeFromNib()
        let contact = CRMContact(value: ["first_name": "Bilbo", "last_name": "Baggings"])

        XCTAssertEqual(view.clientView.clientNameLabel.text, "")
        view.contact = contact
        XCTAssertEqual(view.clientView.clientNameLabel.text, contact.fullName)
    }

    func testSendMail() {
        let view = CRMContactCollectionReusableView(frame: CGRect.zero)
        view.awakeFromNib()
        var dispatched = false

        NSNotificationCenter.defaultCenter().rac_addObserverForName(SWBClientViewCellNewMailNotification, object: nil).subscribeNext({ _ in
            dispatched = true
        })

        XCTAssertFalse(dispatched)
        view.clientView.sendMail(self)
        XCTAssert(dispatched)
    }

    func testDisabledChatIcon() {
        let view = CRMContactCollectionReusableView(frame: CGRect.zero)
        view.awakeFromNib()
        let contact = CRMContact(value: ["first_name": "Bilbo", "last_name": "Baggings", "is_whatsapp_user": false])
        view.contact = contact
        XCTAssertFalse(view.clientView.whatsappButton.enabled)

        contact.is_whatsapp_user = true
        view.contact = contact
        XCTAssert(view.clientView.whatsappButton.enabled)

    }

    func testDisabledPhoneIcon() {
        let view = CRMContactCollectionReusableView(frame: CGRect.zero)
        view.awakeFromNib()
        let contact = CRMContact(value: ["first_name": "Bilbo", "last_name": "Baggings"])
        view.contact = contact
        //Disabled because there is no such information
        XCTAssertFalse(view.clientView.phoneButton.enabled)

        contact.phone = "+3278480480"
        view.contact = contact
        XCTAssert(view.clientView.phoneButton.enabled)
    }
}
