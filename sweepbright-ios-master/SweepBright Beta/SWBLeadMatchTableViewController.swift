//
//  SWBLeadMatchTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBLeadMatchTableViewController: UITableViewController {

    @IBOutlet var clientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let clientViewLoaded = SWBClientViewCell.loadFromNib()
        clientViewLoaded.frame = self.clientView.bounds
        self.clientView.addSubview(clientViewLoaded)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showFeedBack), name: SWBClientViewCellCallNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func showFeedBack() {
        self.performSegueWithIdentifier("feedbackSegue", sender: nil)
    }
}

//MARK: Delegate
extension SWBLeadMatchTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true
        )
    }
}
