//
//  SWBPropertyRoom.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol SWBPropertyRoom: SWBJSONMapper, SWBRealmRequired {
    var rooms: List<SWBRoomClass> {get set}
    var plans: [SWBPlan] {get set}

    //amenities
    var amenities: List<SWBAmenityModel> {get set}

    var floors: Int {get set}

    //General conditions
    var generalCondition: SWBGeneralCondition? {get set}

    //Orientations
    var gardenOrientation: SWBOrientationProtocol? {get set}
    var terraceOrientation: SWBOrientationProtocol? {get set}

    func addOrRemoveAmenity(amenity: SWBAmenity)
}

enum SWBAmenity: String {
    case Pool = "pool"
    case Attic = "attic"
    case Basement = "basement"
    case Terrace = "terrace"
    case Garden = "garden"
    case Parking = "parking"
    case Lift = "lift"
    case GuestHouse = "guesthouse"

    //Parking
    case EletricalGate = "electrical_gate"
    case ManualGate = "manual_gate"
    case Fence = "fence"
    case RemoteControl = "remote_control"
    case KeyCard = "key_card"
    case Code = "code"
    case ClimateControl = "climate_control"

    //Land
    case WaterAccess = "water_access"
    case UtilitiesAccess = "utilities_access"
    case SewerAccess = "sewer_access"
    case Drainage = "drainage"
    case RoadAccess = "road_access"

    var title: String {
        if self == .GuestHouse {
            return "Guest House"
        }
        let title = self.rawValue.stringByReplacingOccurrencesOfString("_", withString: " ")
        return title.capitalizedString
    }

    var icon: UIImage? {
        return UIImage(named: self.rawValue.capitalizedString)
    }
}

class SWBAmenityModel: Object {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var property: SWBPropertyRoomClass?
    dynamic internal var _amenity: String? = nil

    var amenity: SWBAmenity? {
        set(newValue) {
            self._amenity = (newValue?.rawValue) ?? ""
        }get {
            return SWBAmenity(rawValue: self._amenity ?? "")
        }
    }

}
