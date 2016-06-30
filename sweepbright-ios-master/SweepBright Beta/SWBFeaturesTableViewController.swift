//
//  SWBFeaturesTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

class SWBFeaturesTableViewController: UITableViewController {
    var kitchenSlider: SWBGenericGeneralConditionSlider! {
        return self.kitchenSliderView.slider
    }
    var bathroomSlider: SWBGenericGeneralConditionSlider! {
        return self.bathroomSliderView.slider
    }
    @IBOutlet weak var kitchenSliderView: SWBSlider!
    @IBOutlet weak var bathroomSliderView: SWBSlider!
    @IBOutlet weak var yearRenovatedStepper: SWBYearStepper!

    @IBOutlet weak var comfortTableView: SWBFeaturesTableView!
    @IBOutlet weak var hcTableView: SWBFeaturesTableView!
    @IBOutlet weak var energySourceTableView: SWBFeaturesTableView!
    @IBOutlet weak var securityTableView: SWBFeaturesTableView!
    @IBOutlet weak var ecoTableView: SWBFeaturesTableView!
    @IBOutlet weak var permissionsTableView: SWBFeaturesTableView!

    @IBOutlet weak var buildingTableView: SWBBuildingTableView!
    @IBOutlet weak var renovationTableView: SWBRenovationTableView!
    var featuresTableView: [SWBFeaturesTableView] {
        return [self.comfortTableView, self.hcTableView, self.energySourceTableView, self.securityTableView, self.ecoTableView, self.permissionsTableView]
    }
    //Cells
    @IBOutlet weak var bathroomCell: UITableViewCell!
    @IBOutlet weak var kitchenCell: UITableViewCell!
    @IBOutlet weak var comfortCell: UITableViewCell!
    @IBOutlet weak var hcCell: UITableViewCell!
    @IBOutlet weak var energySourceCell: UITableViewCell!
    @IBOutlet weak var securityCell: UITableViewCell!
    @IBOutlet weak var ecoCell: UITableViewCell!
    @IBOutlet weak var buildingCell: UITableViewCell!
    @IBOutlet weak var renovationCell: UITableViewCell!
    @IBOutlet weak var permissionsCell: UITableViewCell!


    var service: SWBFeaturesServiceProtocol = SWBFeaturesService()
    var cells: [SWBSectionCell]!
    var property: SWBProperty!
    var features: SWBFeatures?

    var notificationToken: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateCells()
        self.notificationToken = try! Realm().addNotificationBlock({
            //Update the UI values after save the legal and docs object
            _ in
            self.features = self.property.features
            self.bindData()
        })

        for tableView in self.featuresTableView {
            tableView.reloadData()
        }
        self.bindData()
        self.setDelegates()
    }

    deinit {
        self.notificationToken.stop()
    }

    func setDelegates() {
        self.kitchenSlider.delegate = self
        self.bathroomSlider.delegate = self

        for tableView in self.featuresTableView {
            tableView.service = self
        }
        self.buildingTableView.service = self
        self.renovationTableView.service = self
    }

    func populateCells() {
        switch self.property.type! {
        case .House, .Apartment:
            self.cells = [SWBSectionCell(section: "BATHROOM CONDITION", cell:self.bathroomCell), SWBSectionCell(section: "Kitchen CONDITION", cell: self.kitchenCell), SWBSectionCell(section: "COMFORT", cell: self.comfortCell), SWBSectionCell(section: "H/C System", cell:self.hcCell), SWBSectionCell(section: "ENERGY SOURCE", cell:self.energySourceCell), SWBSectionCell(section: "SECURITY", cell:self.securityCell), SWBSectionCell(section: "ECO", cell:self.ecoCell), SWBSectionCell(section: "BUILDING", cell: self.buildingCell), SWBSectionCell(section: "RENOVATION", cell: self.renovationCell)]
        case .Parking:
            self.cells = [SWBSectionCell(section: "SECURITY", cell:self.securityCell), SWBSectionCell(section: "BUILDING", cell: self.buildingCell), SWBSectionCell(section: "RENOVATION", cell: self.renovationCell)]
        case .Land:
            self.cells =  [SWBSectionCell(section: "PERMISSIONS", cell: self.permissionsCell)]
        default:
            self.cells =  []
        }
    }

    func bindData() {
        if let feature = self.features {
            self.kitchenSlider.setCondition(feature.kitchen, sync: false)
            self.bathroomSlider.setCondition(feature.bathroom, sync: false)
        }
    }

    //MARK: Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SWBFeaturesTableViewController: SWBFeaturesServiceDelegate {

}

extension SWBFeaturesTableViewController: PropertyDependent {
    func propertyDependent(property: SWBProperty) {
        self.property = property
        self.features = property.features
    }
}
class SWBSectionCell {
    var section: String!
    var cell: UITableViewCell!

    init(section: String, cell: UITableViewCell) {
        self.section = section
        self.cell = cell
    }
}
//MARK: DataSource
extension SWBFeaturesTableViewController {

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cells[section].section
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = cells[indexPath.section].cell
        return cell.contentView.frame.height
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cells.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section].cell
    }
}
