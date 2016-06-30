//
//  SWBVisitOverviewTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

let SWBVisitOverviewCellIdentifier = "VisitOverviewCell"
class SWBVisitOverviewTableViewController: UITableViewController, PropertyDependent {
    var showTabBarNavigation: Bool = true
    var property: SWBProperty!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SWBVisitOverviewCellTableViewCell", bundle: nil), forCellReuseIdentifier: SWBVisitOverviewCellIdentifier)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = self.property.address
    }
    // MARK: - Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(SWBVisitOverviewCellIdentifier, forIndexPath: indexPath)
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SELECT YOUR CURRENT VISITOR"
    }
}
