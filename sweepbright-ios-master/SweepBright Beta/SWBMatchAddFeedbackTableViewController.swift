//
//  SWBMatchAddFeedbackTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBMatchAddFeedbackTableViewController: UITableViewController {

    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var feedbackRegistered: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerFeedback(sender: AnyObject) {
        self.feedbackRegistered.hidden = false

        //Wait half second
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
