//
//  SWBArea.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

protocol SWBSurface {
    var room: SWBRoom! {get set}
    var position: CGPoint {get set}
}

protocol SWBPlan: NSObjectProtocol {
    var surfaces: [SWBSurface] {get set}
    var image: UIImage! {get set}
}
