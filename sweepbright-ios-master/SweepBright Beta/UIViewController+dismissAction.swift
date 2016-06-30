//
//  UIViewController+dismissAction.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension UIViewController {
    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
