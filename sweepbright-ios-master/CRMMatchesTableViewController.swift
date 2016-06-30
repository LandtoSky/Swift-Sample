//
//  CRMMatchesTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMMatchesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Matching property"
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
}
