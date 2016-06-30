//
//  SWBBackButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation
import SwiftValidator

protocol SWBBackButtonDelegate {
    func hasChanged() -> Bool
    func updateData()
    var viewController: UIViewController { get }
}

extension SWBBackButtonDelegate {
    func validated() -> Bool {
        return true
    }
}

// SWBBackButton: Should be used to confirm changes on a form screen.
// How to use: Add an UIBarButton on an UINavigationItem and change the button class to SWBBackButton. Using
class SWBBackButton: UIBarButtonItem {
    var backButtonDelegate: SWBBackButtonDelegate!
    var confirmBeforeSave: Bool = false

    @IBOutlet var ibDelegate: AnyObject? {
        didSet {
            if let bbDelegate = self.ibDelegate as? SWBBackButtonDelegate {
                self.backButtonDelegate = bbDelegate
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.action = #selector(SWBBackButton.backButton(_:))
        self.target = self
    }

    //SWBBackButton action
    func backButton(sender: AnyObject) {
        //Force keyboard to dismiss and avoid edit the price after saving and crash the app
        self.backButtonDelegate.viewController.view.endEditing(true)

        //execute the backAction if the delegate is valid
        if self.backButtonDelegate.validated() {
            self.normalAction()
        }
    }
    func popViewController() {
        self.backButtonDelegate.viewController.navigationController?.popViewControllerAnimated(true)
    }

    private func normalAction() {

        //If the form has changed, show a `Save or Discard changes` alert
        if self.backButtonDelegate.hasChanged() {
            if self.confirmBeforeSave {
                AlertFactory.saveAndDiscardChanges(self.backButtonDelegate.viewController, saveChangesHandler: {
                    self.backButtonDelegate.updateData()
                    self.popViewController()
                })
            } else {
                self.backButtonDelegate.updateData()
                self.popViewController()
            }
        //Else just pop the viewcontroller
        } else {
            self.popViewController()
        }
    }
}
