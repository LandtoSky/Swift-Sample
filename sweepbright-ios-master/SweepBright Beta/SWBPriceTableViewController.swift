//
//  SWBPriceTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class SWBPriceTableViewController: SWBPriceDefaultTableViewController {

    @IBOutlet weak var publishedCell: UITableViewCell!
    @IBOutlet weak var priceTextField: MaskTextField!
    @IBOutlet weak var publishedLabel: UILabel!

    override func populateForm() {
        super.populateForm()
        self.publishedLabel.text = self.property.status == .ToLet ? "Published Rent": "Published Price"

        self.priceTextField.numberValue = self.price.value
    }

    override func bindData() {
        super.bindData()
        self.priceTextField.rac_textSignal().subscribeNext({
            _ in
            self.price.value = Float(self.priceTextField.numberValue)
            self.changed = true
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceTextField.resignFirstResponder()
    }
}
