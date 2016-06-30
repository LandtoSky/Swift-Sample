//
//  SWBPriceTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBPriceDefaultTableViewController: UITableViewController, PropertyDependent, SWBBackButtonDelegate {

    @IBOutlet weak var costsTextView: UITextView!
    @IBOutlet weak var taxesTextView: UITextView!
    @IBOutlet var backButton: SWBBackButton!
    var changed: Bool = false

    var property: SWBProperty!
    var price: Price!
    var priceService: SWBPriceServiceProtocol = SWBPriceService()

    func populateForm() {
        self.costsTextView.text = self.price.costs
        self.taxesTextView.text = self.price.taxes
    }

    func bindData() {

        self.costsTextView.rac_textSignal().subscribeNext({
            _ in
            self.price.costs = self.costsTextView.text
        })

        self.taxesTextView.rac_textSignal().subscribeNext({
            _ in
            self.price.taxes = self.taxesTextView.text
        })

        //Combining signals to get when the
        RACSignal.combineLatest([self.costsTextView.rac_textSignal(), self.taxesTextView.rac_textSignal()]).subscribeNext({
            _ in
            self.changed = true
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateForm()
        self.bindData()

        self.changed = false
        self.backButton.backButtonDelegate = self
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //MARK:PropertyDependent
    func propertyDependent(property: SWBProperty) {
        self.property = property
        self.price = Price(value:self.property.price!)
    }

    //MARK: SWBBackButtonDelegate
    func updateData() {
        self.priceService.updatePrice(self.price, completionBlock: nil)
    }

    func hasChanged() -> Bool {
        return self.changed
    }

    func validated() -> Bool {
        return true
    }

    var viewController: UIViewController {
        get {
            return self
        }
    }
}
