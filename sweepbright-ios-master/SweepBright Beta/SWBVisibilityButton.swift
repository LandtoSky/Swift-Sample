//
//  SWBVisibilityButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBVisibilityButton: UIButton {
    var visibility: Visibility? {
        return Visibility(rawValue: self.visibilityValue!)
    }
    @IBInspectable var visibilityValue: String!

}
