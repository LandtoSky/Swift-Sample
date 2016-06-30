//
//  SWBPlan.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBPlanClass: NSObject, SWBPlan {
    var surfaces: [SWBSurface]  = []
    var image: UIImage!

    init(surfaces: [SWBSurface]=[], image: UIImage?=nil) {
        super.init()
        self.image = image
        self.surfaces = surfaces
    }
}
