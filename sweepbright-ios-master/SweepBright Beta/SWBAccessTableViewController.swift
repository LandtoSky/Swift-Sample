//
//  SWBAccessTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa
import RealmSwift

class SWBAccessTableViewController: UITableViewController, PropertyDependent, SWBBackButtonDelegate {

    @IBOutlet weak var currentlyVacant: SWBSwitch!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var keyInPossession: SWBSwitch!

    @IBOutlet weak var alarmCodeTextField: UITextField!
    @IBOutlet weak var alarmCodeCell: UITableViewCell!
    @IBOutlet weak var alarmOnProperty: SWBSwitch!
    @IBOutlet var backButtonBarButton: SWBBackButton!

    var service: SWBAccessServiceProtocol = SWBAccessService()

    var property: SWBProperty! {
        didSet {
            self.visit = Access(value: self.property.access!)
        }
    }
    var changed: Bool = false

    var visit: Access!

    func populateForm() {

        self.currentlyVacant.checked = visit.currentlyVacant
        self.keyInPossession.checked = visit.keyInPossesion
        self.detailsTextView.text = visit.details
        self.alarmCodeTextField.text = visit.alarmCode
        self.alarmOnProperty.checked = visit.alarmOnProperty
        self.alarmCodeCell.hidden = !visit.alarmOnProperty
    }

    func bindData() {

        let detailsTextViewSignals = RACSignal.merge([self.detailsTextView.rac_valuesForKeyPath("text", observer: self), self.detailsTextView.rac_textSignal()])
        detailsTextViewSignals.subscribeNext({
            _ in
            self.visit.details = self.detailsTextView.text
        })

        self.keyInPossession.rac_valueChanged().subscribeNext({
            _ in
           self.visit.keyInPossesion = self.keyInPossession.on
        })

        self.currentlyVacant.rac_valueChanged().subscribeNext({
            _ in
            self.visit.currentlyVacant = self.currentlyVacant.on
        })

        self.alarmCodeTextField.rac_textSignal().subscribeNext({
            _ in
            self.visit.alarmCode = self.alarmCodeTextField.text!
        })

        self.alarmOnProperty.rac_valueChanged().subscribeNext({
            on in
            self.visit.alarmOnProperty = (self.alarmOnProperty.on)

            UIView.animateWithDuration(0.3, animations: {
                self.alarmCodeCell.hidden = !(self.alarmOnProperty.on)
            })
        })

        RACSignal.merge([self.currentlyVacant.rac_valueChanged(), self.keyInPossession.rac_valueChanged(), detailsTextViewSignals, self.alarmOnProperty.rac_valueChanged(), self.alarmCodeTextField.rac_textSignal()]).subscribeNext({
            _ in
            self.changed = true
        })
        self.changed = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonBarButton.backButtonDelegate = self
        self.populateForm()
        self.bindData()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    @IBAction func hideAlarmCode(sender: AnyObject) {
        self.alarmCodeTextField.secureTextEntry = !self.alarmCodeTextField.secureTextEntry
        self.alarmCodeTextField.font = nil
        self.alarmCodeTextField.font = UIFont(name: "LFT Etica", size: 15.0)!
        self.alarmCodeTextField.becomeFirstResponder()
    }

    //MARK: SWBBackButtonDelegate
    func updateData() {
        AlertFactory.loadingTopBarMessage("Sync access data", dismissAfter: 0.5)
        self.service.syncAccess(Access(value: self.visit))
        let realm = try! Realm()
        try! realm.write({
            realm.add(self.visit!, update: true)
        })
    }

    func hasChanged() -> Bool { return self.changed }

    var viewController: UIViewController { return self }

    func validated() -> Bool { return true }
}

//MARK: DataSource
extension SWBAccessTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.property.type == .Land && section == 1 {
            return 1
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
}
