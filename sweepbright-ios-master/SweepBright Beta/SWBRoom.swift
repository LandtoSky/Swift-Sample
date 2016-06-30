//
//  SWBRoom.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class SWBRoomClass: Object, SWBRoom {

    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    var structure: SWBStructure! {
        get {
            return SWBStructure(rawValue: self.type) ?? .Unknownn
        }
        set(newValue) {
            self.type = newValue.rawValue
        }
    }
    dynamic var area: String = "0.0"
    dynamic var type: String = "bedroom"
    dynamic var areaDescription: String = ""
    var units: SWBUnits {
        get {
            return SWBUnits(rawValue: self.unit)!
        }
        set(newValue) {
            self.unit = newValue.rawValue
        }
    }
    internal dynamic var unit: String = "sq_m"

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func ignoredProperties() -> [String] {
        return ["structure", "units"]
    }

    func initWithJSON(json: JSON) {
        self.area = json["size"].stringValue
        self.type = json["type"].stringValue
        self.unit = json["units"].stringValue
        self.areaDescription = json["size_description"].stringValue
    }

    func toJSON() -> [String : AnyObject] {
        return ["size": self.area,
                "type": self.structure.rawValue,
                "units": self.units.rawValue,
                "size_description":self.areaDescription
        ]
    }
}
