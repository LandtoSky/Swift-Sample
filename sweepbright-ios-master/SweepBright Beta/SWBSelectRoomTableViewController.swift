//
//  SWBSelectRoomTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
let SWBSelectRoomTableViewControllerBackInfo = "SWBSelectRoomTableViewControllerBackInfo"
class SWBSelectRoomTableViewController: UITableViewController {
    let datasource = SWBAreaTableViewDataSource()
    var backDelegate: BackInformationDelegate!

    override func viewDidLoad() {
        self.tableView.dataSource = self.datasource
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let room = self.datasource.areas[indexPath.row]
        if let delegate = self.backDelegate {
            delegate.returnInformation(self, info: [SWBSelectRoomTableViewControllerBackInfo: room])
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
