//
//  SWBVisitTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBVisitTableViewController: PropertyTableViewController {
    override var cellNib: UINib! {
        return UINib(nibName: "SWBVisitPropertyCell", bundle: nil)
    }
}
