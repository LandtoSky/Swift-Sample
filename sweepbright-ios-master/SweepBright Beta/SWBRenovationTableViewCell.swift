//
//  SWBRenovationTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

let SWBEditTextCellIdentifier = "SWBEditTextCell"
class SWBEditTextCell: SWBFeatureCell {
    @IBOutlet weak var textView: UITextView!

    override var service: SWBFeaturesServiceDelegate? {
        didSet {
            self.bindData()
        }
    }

    func bindData() {
        self.textView.text = self.property?.features?.renovationDetails
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }
}

extension SWBEditTextCell: UITextViewDelegate {
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.service?.service.syncRenovationDetails(onProperty: self.property!, details: textView.text!)
        return true
    }
}

let SWBRenovatedCellIdentifier = "yearRenovatedCell"
class SWBRenovatedCell: SWBFeatureCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepper: SWBYearStepper!

    override var reuseIdentifier: String? {
        return SWBRenovatedCellIdentifier
    }
    override var service: SWBFeaturesServiceDelegate? {
        didSet {
            self.bindData()
        }
    }

    func bindData() {
        self.stepper.value = self.property?.features?.yearRenovated.value
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindData()

        self.stepper.valueChangeBlock = {
            self.service?.service.syncYearRenovated(onProperty: self.property!, year: self.stepper.value)
        }
    }
}
