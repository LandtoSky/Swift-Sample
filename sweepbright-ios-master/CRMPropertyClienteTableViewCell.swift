//
//  CRMPropertyClienteTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMPropertyClientTableViewCell: UITableViewCell {

    var clientView: SWBClientViewCell!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.clientView = SWBClientViewCell.loadFromNib()
        self.clientView.frame = self.bounds

        self.addSubview(self.clientView)
    }
}
