//
//  SWBNewPropertyViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBNewPropertyViewController: UIViewController {
    let addPropertyIdentifier = "addProperty"
    var negotiation: SWBPropertyNegotiation!

    @IBAction func newPropertyForSale(sender: AnyObject) {
        self.negotiation = .ForSale
        self.performSegueWithIdentifier(addPropertyIdentifier, sender: sender)
    }

    @IBAction func newPropertyToLet(sender: AnyObject) {
        self.negotiation = .ToLet
        self.performSegueWithIdentifier(addPropertyIdentifier, sender: sender)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == addPropertyIdentifier {
            let destination = segue.destinationViewController as!
            SWBNewPropertyTableViewController
            destination.negotiation = self.negotiation
        }
        super.prepareForSegue(segue, sender: sender)
    }
}
