//
//  SWBPastVisitTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBPastVisitTableViewCell: UITableViewCell {

    var visitClientView: SWBPastVisitClientView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.visitClientView = SWBPastVisitClientView.loadFromNib()
        self.visitClientView.frame = self.bounds
        self.addSubview(self.visitClientView)
    }

}
