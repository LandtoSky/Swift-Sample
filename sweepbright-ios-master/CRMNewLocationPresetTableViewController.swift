//
//  CRMNewLocationPresetTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMNewLocationPresetTableViewController: UIViewController, SectionDatasource {
    @IBOutlet weak var tableView: UITableView!

    var sections: [Section] = [
        Section(title: "Name", cells: ["areaNameCell"]),
        Section(title: "Included Areas", cells: ["postcodeCell", "postcodeCell", "postcodeCell", "footerCell"]),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
}

extension CRMNewLocationPresetTableViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = self.sections[indexPath.section].cells[indexPath.row]
        return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}
