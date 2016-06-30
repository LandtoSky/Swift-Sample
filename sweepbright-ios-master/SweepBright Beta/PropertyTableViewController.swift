//
//  PropertyTableViewController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

class PropertyTableViewController: UITableViewController {
    var propertyService: SWBPropertyServiceProtocol = SWBPropertyService()

    //Static list of properties
    var properties: Results<SWBPropertyModel>!
    let realm = try! Realm()
    var filteredProperties: [SWBProperty] = []
    var token: NotificationToken!
    var selectedProperty: SWBProperty!

    var cellNib: UINib! {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(self.cellNib, forCellReuseIdentifier: "PropertyCell")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PropertyTableViewController.refreshProperties), name: SWBFilterNotification, object: nil)
        self.refreshProperties()
        self.token = self.properties.addNotificationBlock({ _ in
            self.tableView.reloadData()

            if self.properties.count > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor()
        super.viewDidAppear(animated)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OverviewSegue" {
            (segue.destinationViewController as! PropertyDependent).propertyDependent(self.selectedProperty)
            segue.destinationViewController.hidesBottomBarWhenPushed = true
        }
        super.prepareForSegue(segue, sender: sender)
    }

    func refreshProperties() {
        self.properties = realm.objects(SWBPropertyModel).filter(SWBFilter.sharedFilter).sorted("updated_at", ascending: false)
        self.tableView.reloadData()
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        propertyService.updateListOfProperties(nil)
    }

    //MARK: TableView
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? PropertyTableViewCell {
            //Get the propert object from datasource
            let property = self.properties[indexPath.row]
            cell.property = property
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.properties.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("PropertyCell")!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedProperty = properties[(self.tableView.indexPathForSelectedRow?.row)!]
        self.performSegueWithIdentifier("OverviewSegue", sender: self)
    }

}
