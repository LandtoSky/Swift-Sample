//
//  SWBVisitPropertyCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBVisitPropertyCell: PropertyTableViewCell {
    override var property: SWBProperty! {
        didSet {
            self.statusLabel.text = "Current location"
            self.costLabel.text = "€ \(self.property.price!.valueFormated) \(self.property.status == SWBPropertyNegotiation.ToLet ? "/ month" : "")"
            self.addressLabel.text = self.property.address
        }
    }
}
