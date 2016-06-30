//
//  SWBOrientationButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBOrientationButton: UIButton {
    var roomOrientation: SWBOrientationProtocol!

    var orientationHasChanged:((newOrientation: SWBOrientation)->())? = nil

    var orientation: SWBOrientation = .N {
        didSet {
            self.setTitle("Set \(orientation.fullName())", forState: .Normal)
            self.orientationHasChanged!(newOrientation: self.orientation)
        }
    }
}
