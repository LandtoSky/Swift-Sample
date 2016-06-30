//
//  CRMSettingsTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMSettingsTableViewController: UITableViewController, CRMContactDependent, CRMContactService {
    var contact: CRMContact!
    var queue: NSOperationQueue!
    var contactService: protocol<CRMContactService>!
    @IBOutlet weak var archiveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.queue = NSOperationQueue()
        self.contactService = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateArchiveButtonTitle()
    }

    /**
     Update the archive button title to **archive** or **unarchive**.

     The text will be based on the contact archived value.
    */
    func updateArchiveButtonTitle() {
        self.archiveButton.setTitle(self.contact.is_archived ? "Unarchive Lead" : "Archive Lead", forState: .Normal)
    }
    @IBAction func archiveLead(sender: AnyObject) {
        AlertFactory.loadingTopBarMessage("Changing archive status", dismissAfter: 0.5)
        self.contactService.changeArchiveStatus(fromContact: self.contact, completionBlock: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // - MARK: Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
