//
//  CRMLeadPreferencesTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import CoreLocation

class CRMLeadPreferencesTableViewController: UITableViewController, CRMContactDependent {

    @IBOutlet weak var mapView: SWBMapView!
    var locationManager: CLLocationManager!
    var contact: CRMContact!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        self.mapView.center(onCoordinate: CLLocationCoordinate2D(latitude: 50.87966, longitude: 4.7130369))
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var destination = segue.destinationViewController as? CRMContactDependent {
            destination.contact = self.contact
        }
        super.prepareForSegue(segue, sender: sender)
    }
}
