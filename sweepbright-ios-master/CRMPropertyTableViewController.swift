//
//  CRMPropertyTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift
class CRMPropertyTableViewController: UITableViewController {
    var queue: NSOperationQueue!
    let CRMContactCellReuseIdentifier = "contactCell"
    var contacts: Results<CRMContact>!
    var token: NotificationToken?
    var cellNib: UINib! {
        return UINib(nibName: "CRMPropertyCell", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.queue = NSOperationQueue()
        let realm = try! Realm()
        self.contacts = realm.getAllContacts()
        self.token = self.contacts.addNotificationBlock({ (_: RealmCollectionChange) in
            self.tableView.reloadData()
        })

        self.tableView.registerNib(self.cellNib, forCellReuseIdentifier: CRMContactCellReuseIdentifier)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showContactDetails), name: CRMNewContactAddedNotification, object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    deinit {
        self.token?.stop()
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        AlertFactory.loadingTopBarMessage("Updating list of contacts")
        self.updateContactsList({
            dispatch_async(dispatch_get_main_queue(), {
                sender.endRefreshing()
                AlertFactory.dismissTopBarMessage()
            })
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var destinationView = segue.destinationViewController as? CRMContactDependent, let contact = sender as? CRMContact {
            destinationView.contact = contact
        }
        super.prepareForSegue(segue, sender: sender)
    }

    func showContactDetails(notification: NSNotification) {
        let realm = try! Realm()
        if let contactId = notification.object as? String, let contact = realm.objectForPrimaryKey(CRMContact.self, key: contactId) {
            self.performSegueWithIdentifier("contactDetail", sender: contact)
        }
    }
}

//MARK: Contacts Service
extension CRMPropertyTableViewController: CRMContactService {

}

//MARK: DataSource
extension CRMPropertyTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CRMContactCell).contact = self.contacts[indexPath.row]
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CRMContactCellReuseIdentifier, forIndexPath: indexPath) as! CRMContactCell
        return cell
    }
}

//MARK: Delegate
extension CRMPropertyTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let contact: CRMContact? = self.contacts[indexPath.row] {
            self.performSegueWithIdentifier("contactDetail", sender: contact)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
