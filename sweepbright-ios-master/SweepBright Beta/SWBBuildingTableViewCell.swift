//
//  SWBBuildingTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

let SWBYearBuiltCellIdentifier = "yearBuiltCell"
class SWBYearBuiltCell: SWBFeatureCell {

    override var reuseIdentifier: String? {
        return SWBYearBuiltCellIdentifier
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepper: SWBYearStepper!

    override var service: SWBFeaturesServiceDelegate? {
        didSet {
            self.bindData()
        }
    }

    func bindData() {
        self.stepper.value = self.property?.features?.yearBuilt.value
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.stepper.valueChangeBlock = {
            self.service?.service.syncYearBuilt(onProperty: self.property!, year: self.stepper.value)
        }
    }
}

let SWBArchitectCellIdentifier = "architectCell"
class SWBArchitectCell: SWBFeatureCell {
    override var reuseIdentifier: String? {
        return SWBArchitectCellIdentifier
    }
    @IBOutlet weak var architectTextField: UITextField!

    override var service: SWBFeaturesServiceDelegate? {
        didSet {
            self.bindData()
        }
    }

    func bindData() {
        self.architectTextField.text = self.property?.features?.architect
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.architectTextField.rac_signalForControlEvents(.EditingDidEnd).subscribeNext({
            _ in
            self.service?.service.syncArchitect(onProperty: self.property!, architect: self.architectTextField.text!)
        })
    }
}
