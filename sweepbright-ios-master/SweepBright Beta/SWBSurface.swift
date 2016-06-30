//
//  SWBSurface.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBSurfaceClass: NSObject, SWBSurface {
    var room: SWBRoom!
    var position: CGPoint = CGPoint.zero

    init(position: CGPoint = CGPoint.zero) {
        super.init()

        self.position = position
    }
}
