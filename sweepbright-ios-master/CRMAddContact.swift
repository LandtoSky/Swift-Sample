//
//  CRMAddContact.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

/// This label has 15px of left-padding
class LabelWithPadding: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)))
    }
}

/// This UISegmentedControl has borderWidth equals to 1.0 and the color
class BorderLessSegmentControl: UISegmentedControl {
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.layer.borderColor = UIColor.getBorderColor().CGColor
        self.layer.borderWidth = 1.0
    }
}

class CRMAddContact: UIViewController, CRMContactService {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    @IBOutlet var contactForm: CRMContactForm!
    @IBOutlet weak var typeOfContactSegment: BorderLessSegmentControl!

    var queue: NSOperationQueue!
    var contact: CRMContact {
        get {
            return self.contactForm.contact
        } set (newValue) {
            self.contactForm.contact = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.queue = NSOperationQueue()
        self.addKeyboarNotifications()
        self.contactForm.addReactions()
        self.contact = CRMContact(value: ["type": "lead"])

        self.typeOfContactSegment.rac_signalForControlEvents(.ValueChanged).subscribeNext({ _ in
            self.contact.contactType = self.typeOfContactSegment.selectedSegmentIndex == 0 ? .Lead : .Vendor
        })
        self.contactForm.rac_formIsValid().subscribeNext({ _ in
            self.addContactButton.enabled = self.contactForm.formIsValid
        })
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }

    private func addKeyboarNotifications() {

        //This will hide the type stack view when the keyboard shows up
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil)
            .subscribeNext({ _ in
                self.topConstraint.constant = -80
            })
        //This will back to the normal screen
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil)
            .subscribeNext({ _ in
                self.topConstraint.constant = 20
            })
    }

    @IBAction func addContact(sender: AnyObject) {
        self.addNewContact(self.contact)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
