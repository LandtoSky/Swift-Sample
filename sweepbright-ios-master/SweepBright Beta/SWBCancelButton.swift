//
//  SWBCancelButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBCancelButton: UIBarButtonItem {

    @IBOutlet var viewController: UIViewController!


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        //setting the action to a local method
        self.action = #selector(SWBCancelButton.cancel(_:))
        self.target = self
    }

    func cancel(sender: UIBarButtonItem) {
        self.viewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
