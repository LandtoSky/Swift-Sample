//
//  CRMPropertyContactsTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMPropertyContactsTableViewController: UITableViewController {
    let CRMPropertyContactCell = "CRMPropertyContactCell"
    let sections = ["Vendors", "Leads"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "CRMPropertyContactTableViewCEll", bundle: nil), forCellReuseIdentifier: CRMPropertyContactCell)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Contacts for property"
    }
}

//MARK: DataSource
extension CRMPropertyContactsTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(CRMPropertyContactCell, forIndexPath: indexPath)
    }
}

//MARK: Delegate
extension CRMPropertyContactsTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("contactInfo", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
