//
//  SWBFilterPropertiesTableTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

let SWBFilterNotification: String = "NewFilter"

struct SWBFilter {
    var negotiation: SWBPropertyNegotiation?
    var propertyTypes: [SWBPropertyType] = [.House, .Apartment, .Land, .Parking, .Retail, .Office]

    static var sharedFilter: SWBFilter = SWBFilter() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(SWBFilterNotification, object: nil)
        }
    }
}

class SWBFilterPropertiesTableTableViewController: UITableViewController {

    @IBOutlet weak var ownerSegment: UISegmentedControl!
    @IBOutlet weak var negotiationSegment: SWBNegotiationSegmentControl!

    @IBOutlet weak var houseSwitch: SWBSwitch!
    @IBOutlet weak var apartmentSwitch: SWBSwitch!
    @IBOutlet weak var landSwitch: SWBSwitch!
    @IBOutlet weak var parkingSwitch: SWBSwitch!
    @IBOutlet weak var retailSwitch: SWBSwitch!
    @IBOutlet weak var officeSwitch: SWBSwitch!

    var switches: [SWBSwitch?] {
        return [houseSwitch, apartmentSwitch, landSwitch, parkingSwitch, retailSwitch, officeSwitch]
    }

    var filter: SWBFilter! {
        didSet {
            self.negotiationSegment?.negotiation = self.filter.negotiation

            //Enable or disable the toggles
            for toggle in self.switches {
                toggle?.checked = (self.filter.propertyTypes.filter({$0.rawValue == toggle?.value}).count > 0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.filter = SWBFilter.sharedFilter
        self.binding()
    }

    func binding() {
        //Binding negotiation segment
        self.negotiationSegment.rac_signalForControlEvents(.ValueChanged).subscribeNext({
            _ in
            self.filter.negotiation = self.negotiationSegment.negotiation
        })

        RACSignal.combineLatest(self.switches.map({ $0!.rac_checked() })).subscribeNext({
            _ in
            //Update list of property types
            self.filter.propertyTypes = self.switches.filter({$0!.on}).map({SWBPropertyType(rawValue: $0!.value)!})
        })
    }

    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func filterProperties(sender: AnyObject) {
        SWBFilter.sharedFilter = self.filter
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
