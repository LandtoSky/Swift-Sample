//
//  SWBPropertyTypeButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBPropertyTypeButton: UIButton {

    @IBInspectable var type: String {
        get {
            return self.typeOfProperty.rawValue
        }set (newValue) {
            self.typeOfProperty = SWBPropertyType(rawValue: newValue) ?? .House
        }
    }
    var typeOfProperty: SWBPropertyType!
}
