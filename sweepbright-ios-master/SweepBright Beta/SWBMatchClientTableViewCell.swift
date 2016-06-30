//
//  SWBMatchClientTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBMatchClientTableViewCell: UITableViewCell, CRMContactDependent {
    var contact: CRMContact! {
        didSet {
            self.clientView?.contact = self.contact
        }
    }
    var mailed: Bool = false {
        didSet {
            self.clientView.mailButton.setImage(UIImage(named: mailed ? "mailed" : "mail"), forState: .Normal)
        }
    }
    var clientView: SWBClientViewCell!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.clientView = SWBClientViewCell.loadFromNib()
        self.clientView.frame = self.bounds

        self.addSubview(self.clientView)
    }
}
