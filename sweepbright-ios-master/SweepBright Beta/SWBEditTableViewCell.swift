//
//  SWBEditTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBEditTableViewCell: PropertyTableViewCell {
    override var property: SWBProperty! {
        didSet {
            let timestamp = NSDateFormatter.localizedStringFromDate(self.property.updated_at, dateStyle: .MediumStyle, timeStyle: .MediumStyle)
            self.statusLabel.text = "Edited \(timestamp)"
            self.costLabel.text = "€ \(self.property.price!.valueFormated) \(self.property.status == SWBPropertyNegotiation.ToLet ? "/ month" : "")"
            self.addressLabel.text = self.property.address
        }
    }
}
