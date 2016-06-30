//
//  SWBPropertySettingsTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBPropertySettingsTableViewController: UITableViewController, PropertyDependent {
    var property: SWBProperty! {
        didSet {
            self.settings = self.property.settings!
        }
    }
    var settings: SWBPropertySettings!
    var service: SWBSettingsServiceProtocol = SWBSettingsService()
    @IBOutlet weak var advertisementAllowedSwitch: SWBSwitch!
    @IBOutlet weak var advertisementAvailableFromDate: SWBDateButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    var changed = false

    @IBOutlet weak var mandateEndDate: SWBDateButton!
    @IBOutlet weak var mandateStartDate: SWBDateButton!

    @IBOutlet weak var stateOfSale: SWBStateSale!
    @IBOutlet weak var stateOfSaleLetLabels: UIStackView!
    @IBOutlet weak var stateOfSaleForSaleLabels: UIStackView!

    @IBOutlet weak var officeNegotiator: UITextField!
    @IBOutlet weak var officeReference: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stateOfSaleLetLabels?.hidden = self.property.status == .ForSale
        self.stateOfSaleForSaleLabels?.hidden = self.property.status == .ToLet
        self.stateOfSale.property = self.property
        self.bindData()
        self.setReactiveAction()
    }

    func bindData() {
        self.advertisementAllowedSwitch.setOn(self.settings.allowed)
        self.advertisementAvailableFromDate.date = self.settings.from
        self.notesTextView.text = self.settings.notes
        self.mandateStartDate.date = self.settings.startDate
        self.mandateEndDate.date = self.settings.endDate
        self.officeNegotiator.text = self.settings.negotiator
        self.officeReference.text = self.settings.reference
        self.stateOfSale.stateSale = self.settings.statusProperty
    }

    @IBAction func archiveProperty(sender: AnyObject) {
        let alert = UIAlertController(title: "Archive & Unpublish", message: "Archiving this property will unpublish this property as well.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Don't archive", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Archive", style: .Default, handler: {
            _ in
            self.service.archiveProperty(self.property.id)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    private func isMandateDatesValid() -> Bool {
        //If one of the dates are nil return true
        if mandateStartDate.date == nil || mandateEndDate.date == nil {
            return true
        }
        return self.mandateStartDate.date!.compare(self.mandateEndDate.date!) == .OrderedAscending
    }

    func setReactiveAction() {
        self.advertisementAvailableFromDate.rac_dateChanged.subscribeNext({
            _ in
            self.service.syncAdvertisementFrom(self.property.id, withDate: self.advertisementAvailableFromDate.date!)
        })
        self.mandateStartDate.rac_dateChanged.subscribeNext({
            _ in
            //Prevent endDate to be smaller than start date
            if self.isMandateDatesValid() {
                if let startDate = self.mandateStartDate.date {
                    self.service.syncMandateStartDate(self.property.id, withDate: startDate)
                }
            } else {
                AlertFactory.loadingTopBarMessage("The start date should be smaller than the end date", dismissAfter: 3.0, style: .Error)
                self.mandateStartDate.date = nil
            }
        })
        self.mandateEndDate.rac_dateChanged.subscribeNext({
            _ in
            //Prevent endDate to be smaller than start date
            if self.isMandateDatesValid() {
                if let endDate = self.mandateEndDate.date {
                    self.service.syncMandateEndDate(self.property.id, withDate: endDate)
                }
            } else {
                AlertFactory.loadingTopBarMessage("The start date should be smaller than the end date", dismissAfter: 3.0, style: .Error)
                self.mandateEndDate.date = nil
            }
        })
        self.advertisementAllowedSwitch.rac_valueChanged().subscribeNext({
            _ in
            self.service.syncAdvertisementAllowed(self.property.id, allowed: self.advertisementAllowedSwitch.on)
        })

        self.officeReference.rac_signalForControlEvents(.EditingDidEnd).subscribeNext({
            _ in
            self.service.syncOfficeReference(self.property.id, reference: self.officeReference.text!)
        })

        self.officeNegotiator.rac_signalForControlEvents(.EditingDidEnd).subscribeNext({
            _ in
            self.service.syncOfficeNegotiator(self.property.id, negotiator: self.officeNegotiator.text!)
        })

        self.stateOfSale.rac_valueChanged.subscribeNext({
            _ in
            self.service.syncStateOfSale(self.property.id, state: self.stateOfSale.stateSale)
        })

        RACSignal.merge([self.notesTextView.rac_textSignal(), self.notesTextView.rac_valuesAndChangesForKeyPath("text", options: .New, observer: nil)])
            .subscribeNext({
                _ in
                self.changed = true
        })
        self.changed = false
    }
}
extension SWBPropertySettingsTableViewController: SWBBackButtonDelegate {
    var viewController: UIViewController {
        return self
    }

    func hasChanged() -> Bool {
        return self.changed
    }
    func updateData() {
        self.service.syncNotes(self.property.id, notes: self.notesTextView.text!)
    }
}
//MARK: Delegate
extension SWBPropertySettingsTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
