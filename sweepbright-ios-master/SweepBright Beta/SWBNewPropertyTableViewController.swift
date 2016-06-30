//
//  SWBNewPropertyTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

protocol SWBNewPropertyProtocol {
    var propertyService: SWBPropertyServiceProtocol {get}
    var negotiation: SWBPropertyNegotiation {get}
}

class SWBNewPropertyTableViewController: UITableViewController, SWBNewPropertyProtocol {
    var propertyService: SWBPropertyServiceProtocol = SWBPropertyService()
    var negotiation: SWBPropertyNegotiation = .ToLet

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SWBNewPropertyTableViewCell
        guard let _ = cell.typeOfProperty else {
            return
        }

        let property: PropertyID = propertyService.createNewProperty(cell.typeOfProperty!, negotiation: self.negotiation, completionBlock: nil)
        SWBNewPropertyAddedNotification.dispatchNewPropertyHasBeenAdded(propertyWithId: property)

        self.dismissViewControllerAnimated(true, completion: {

        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addProject" {
            let destination = segue.destinationViewController as! SWBNewProjectViewController
            destination.propertyViewController = self
        }
        super.prepareForSegue(segue, sender: sender)
    }
}
