//
//  SWBUnitTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBUnitTableViewController: UITableViewController, PropertyDependent {

    @IBOutlet var customHeaderSection: UIStackView!
    @IBOutlet var addUnitButton: UIButton!
    @IBOutlet weak var ratingSlider: SWBColouredUISlider!
    @IBOutlet weak var labelSituation: UILabel!

    let titlesLabel = ["Poor", "Fair", "Good", "Mint", "New"]
    let coloursOrder = UIColor.getSliderArrayOfColours()
    var property: SWBProperty!
    var project: SWBProjectProtocol!

    @IBOutlet weak var unitsTableView: SWBUnitLevelsTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitsTableView.listOfUnits = self.project.listOfUnits
    }

    //MARK: PropertyDependent
    func propertyDependent(property: SWBProperty) {
        self.property = property
        self.project = property.project
    }

    //MARK: TableView delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
