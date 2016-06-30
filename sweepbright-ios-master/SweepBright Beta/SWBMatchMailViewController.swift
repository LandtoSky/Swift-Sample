//
//  SWBMatchMailViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBMatchMailViewController: UIViewController {
    let keyboardHeight: CGFloat = 250.0
    @IBOutlet var keyboardBar: UIToolbar!
    @IBOutlet weak var mailTextView: UITextView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mailTextView.inputAccessoryView = self.keyboardBar
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.stackViewBottomConstraint.constant = 0
        })
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.stackViewBottomConstraint.constant = self.keyboardHeight
        })
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
