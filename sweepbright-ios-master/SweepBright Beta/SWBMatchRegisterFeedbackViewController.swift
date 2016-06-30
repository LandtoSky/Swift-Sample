//
//  SWBMatchRegisterFeedbackViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBMatchRegisterFeedbackViewController: UIViewController {

    @IBOutlet weak var clientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let clientView = SWBOwnerFeedbackView.loadFromNib()
        clientView.frame = self.clientView.bounds
        self.clientView.addSubview(clientView)
    }

    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
