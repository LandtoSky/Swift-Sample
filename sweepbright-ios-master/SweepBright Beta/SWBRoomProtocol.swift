//
//  SWBRoom.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

public enum SWBUnits: String {
    case Meter = "sq_m"
    case Foot = "sq_ft"
}

public enum SWBStructure: String {
    case Bedroom = "bedroom"
    case Bathroom = "bathroom"
    case WC = "wc"
    case Kitchen = "kitchen"
    case LivingRoom = "living_room"
    case Unknownn = ""
}

protocol SWBRoom: SWBJSONMapper {
    var id: String {get set}
    var structure: SWBStructure! { get set}
    var area: String {get set}
    var areaDescription: String {get set}
    var units: SWBUnits {get set}

}
