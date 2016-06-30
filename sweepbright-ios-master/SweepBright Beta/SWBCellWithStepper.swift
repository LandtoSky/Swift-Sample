//
//  SWBCellWithStepper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBFloorCell: UITableViewCell {
    var property: SWBProperty!

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepper: SWBYearStepper!

    func initialize() {
        self.stepper.valueChangeBlock = {

        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
}
