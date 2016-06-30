//
//  SWBVisitOverviewCellTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBVisitOverviewCellTableViewCell: UITableViewCell {

    var visitClientView: SWBVisitClientView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.visitClientView = SWBVisitClientView.loadFromNib()
        self.visitClientView.frame = self.bounds
        self.addSubview(self.visitClientView)
    }
}
