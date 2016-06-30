//
//  SWBOrientation.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/23/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation


enum SWBOrientation: String {
    case N = "N"
    case NE = "NE"
    case E = "E"
    case SE = "SE"
    case S = "S"
    case SW = "SW"
    case W = "W"
    case NW = "NW"

    func fullName() -> String {
        switch self {
        case .N:
            return "North"
        case .NE:
            return "North-East"
        case .E:
            return "East"
        case .SE:
            return "South-East"
        case .S:
            return "South"
        case .SW:
            return "South-West"
        case .W:
            return "West"
        case .NW:
            return "North-West"
        }
    }
}
