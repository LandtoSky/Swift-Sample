//
//  SWBAreaTableViewDelegate.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBAreaTableViewDelegate: NSObject, UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SWBAreaTableViewCell

        cell.areaTextField.becomeFirstResponder()
    }
}
