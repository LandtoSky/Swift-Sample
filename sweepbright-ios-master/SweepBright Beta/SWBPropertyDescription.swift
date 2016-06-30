//
//  SWBPropertyDescription.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftValidator

class SWBPropertyDescription: UITableViewController, PropertyDependent, SWBBackButtonDelegate, ValidationDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var counterLabel: CounterLabel!
    @IBOutlet var backButtonBarButton: SWBBackButton!

    @IBOutlet var descriptionHeaderView: UIView!
    @IBOutlet weak var titleLabel: SWBNotEmptyLabel!

    @IBOutlet weak var titleCell: UITableViewCell!
    var property: SWBProperty!
    let validator = Validator()
    var descriptionService: SWBDescriptionServiceProtocol = SWBDescriptionService()

    func propertyDependent(property: SWBProperty) {
        self.property = property
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonBarButton.backButtonDelegate = self
        self.navigationItem.leftBarButtonItem?.title = "Save"

        self.descriptionTextView.text = self.property.desc
        self.titleText.text = self.property.title

        //Updating counterLabel.currentCounter when start typing
        self.descriptionTextView.rac_textSignal().subscribeNext({
            text in
                self.counterLabel.currentCounter = self.descriptionTextView.text.characters.count
        })
        self.titleText.rac_textSignal().subscribeNext({
            _ in
            self.titleLabel.currentCounter = self.titleText.text!.characters.count
        })

        //Set validator
        validator.registerField(self.titleText, errorLabel:self.titleLabel, rules: [RequiredRule()])

        // Focus
        self.titleText.becomeFirstResponder()
    }

    @IBAction func clearDescription(sender: AnyObject) {
        self.descriptionTextView.text = ""
        self.counterLabel.currentCounter = self.descriptionTextView.text.characters.count
    }

    //MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.descriptionHeaderView
        }
        return nil
    }

    //MARK:SWBBackButtonDelegate
    func updateData() {
        self.descriptionService.updateDescriptionAndtitle(SWBDescriptionParameter(id:property.id, title: self.titleText.text!, desc:self.descriptionTextView.text))
    }

    var viewController: UIViewController {
        get {
            return self
        }
    }

    func validated() -> Bool {
        self.validator.validate(self)
        return self.validator.errors.isEmpty
    }

    func hasChanged() -> Bool {
        return (self.titleText.text != self.property.title) || (self.descriptionTextView.text != self.property.desc)
    }

    //MARK: ValidationDelegate
    func validationSuccessful() {

    }

    func validationFailed(errors: [UITextField : ValidationError]) {
        AlertFactory.errorNotification(self, message: "Check the red field(s)")
    }
}
