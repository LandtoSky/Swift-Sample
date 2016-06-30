//
//  SWBNegotiationSegmentControl.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBNegotiationSegmentControl: BorderLessSegmentControl {
    let negotiations: [SWBPropertyNegotiation?] = [nil, .ToLet, .ForSale]

    var negotiation: SWBPropertyNegotiation? {
        set(newValue) {
            let negotiationElement = self.negotiations.enumerate().filter({ $1 == newValue }).first
            self.selectedSegmentIndex = negotiationElement?.index ?? 0
        }get {
            return self.negotiations[self.selectedSegmentIndex]
        }
    }
}
