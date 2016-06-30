//
//  SWBOfflineQueueTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

class SWBOfflineQueueTableViewController: UITableViewController {
    var token: NotificationToken!
    var requestsList: Results<SWBOfflineRequest>!
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestsList = self.realm.objects(SWBOfflineRequest).sorted("createdAt")
        self.token = self.requestsList.addNotificationBlock({
            (_: RealmCollectionChange) in
            print("offline queue has changed")
            self.tableView.reloadData()
        })
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let offline = SWBOfflineQueue.sharedInstance.requests[indexPath.row]
        debugPrint(offline)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OfflineCell")
        let offline = self.requestsList[indexPath.row]
        cell?.textLabel?.text = offline.url
        let formatter = NSDateFormatter()
        cell?.detailTextLabel!.text = formatter.stringFromDate(offline.createdAt)
        return cell!
    }
}
