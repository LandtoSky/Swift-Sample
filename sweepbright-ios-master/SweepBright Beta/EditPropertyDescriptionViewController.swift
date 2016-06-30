//
//  EditPropertyDescriptionViewController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/27/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class EditPropertyDescriptionViewController: UITableViewController {

    @IBOutlet weak var descriptionText: UITextView!

    var backInfoDelegate: BackInformationDelegate!
    var descriptionValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionText.text = descriptionValue
        self.descriptionText.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        self.backInfoDelegate.returnInformation(self, info: ["description":self.descriptionText.text])
        super.viewWillDisappear(animated)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Description"
    }
}
