//
//  SWBNewPropertyForSaleViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBNewProjectViewController: UIViewController {
    var propertyViewController: SWBNewPropertyProtocol?

    @IBAction func addNewProperty(sender: SWBPropertyTypeButton) {
        if let property: PropertyID = propertyViewController?.propertyService.createProject(sender.typeOfProperty, negotiation: propertyViewController!.negotiation, completionBlock: nil) {
            SWBNewPropertyAddedNotification.dispatchNewPropertyHasBeenAdded(propertyWithId: property)
        }
        self.dismissViewControllerAnimated(true, completion: {
        })
    }
}
