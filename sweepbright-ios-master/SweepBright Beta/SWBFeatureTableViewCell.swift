//
//  SWBFeatureTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBFeatureSwitchCell: SWBFeatureCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggle: SWBSwitch!

    var parameter: SWBFeatureParameter! {
        didSet {
            self.titleLabel?.text = parameter.feature.title()
            let index = self.parameter.property?.features?.listOfFeatures.indexOf(self.parameter.feature)

            self.toggle.rac_valueChanged().subscribeNext({
                _ in
                self.service?.service.syncFeatures(onProperty: self.parameter.property!, onTheGroup: self.parameter.group, value: self.parameter.feature)
            })
            //Will not dispatch the signal ☝️
            self.toggle.checked = (index != nil)
        }
    }
}
