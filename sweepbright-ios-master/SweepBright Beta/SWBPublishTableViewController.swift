//
//  SWBPublishTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBPublishTableViewController: PropertyTableViewController {
    override var cellNib: UINib! {
        //TYPO
        return UINib(nibName: "SWBPublichPropertyCell", bundle: nil)
    }
}
