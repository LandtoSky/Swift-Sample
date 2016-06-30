//
//  CRMAddLocationPresetTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class CRMLocationPresetTableViewCell: UITableViewCell {
    @IBOutlet weak var mapView: SWBMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

    var location: CRMLocationPreference! {
        didSet {
            self.mapView?.center(fromAddress: location.name)
            self.titleLabel.text = location.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CRMLocationPreferencesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, CRMContactDependent {
    var contact: CRMContact!
    var locations: List<CRMLocationPreference>!

    init(contact: CRMContact) {
        self.contact = contact
        self.locations = self.contact.preferences?.locations
    }
    // - MARK: DataSource
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PRESETS"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("locationCell")!
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    // - MARK: Delegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let locationCell = cell as? CRMLocationPresetTableViewCell {
            locationCell.location = self.locations[indexPath.row]
        }
    }
}

class CRMAddLocationPresetTableViewController: UIViewController, CRMContactDependent {
    @IBOutlet weak var tableView: UITableView!
    var contact: CRMContact!
    var tableViewDatasource: CRMLocationPreferencesDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewDatasource = CRMLocationPreferencesDataSource(contact: self.contact)
        self.tableView.dataSource = self.tableViewDatasource
        self.tableView.delegate = self.tableViewDatasource
    }
}
