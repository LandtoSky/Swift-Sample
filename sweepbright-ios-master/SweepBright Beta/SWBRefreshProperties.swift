//
//  SWBRefreshProperties.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBRefreshProperties: UIRefreshControl {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.targetForAction(#selector(endRefreshing), withSender: self)
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        print("Refreshing")
        self.endRefreshing()
    }
}
