//
//  SWBEditTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBEditTableViewController: PropertyTableViewController {
    override var cellNib: UINib! {
        return UINib(nibName: "SWBEditPropertyCell", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showProperty), name: SWBNewPropertyAddedNotification.newPropertyNotificationName, object: nil)
    }

    func showProperty(notification: NSNotification) {
        if let id = notification.object as? PropertyID, let property = self.realm.objectForPrimaryKey(SWBPropertyModel.self, key: id) {
            self.selectedProperty = property
            self.performSegueWithIdentifier("OverviewSegue", sender: nil)
        }
    }
}
