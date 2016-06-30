//
//  SWBPropertyRoom.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class SWBPropertyRoomClass: Object, SWBPropertyRoom {
    var plans: [SWBPlan] = []

    var rooms = List<SWBRoomClass>()

    //amenities
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var property: SWBPropertyModel?
    dynamic var floors: Int = 0
    dynamic internal var terraceLocation: String?
    dynamic internal var gardenLocation: String?

    var amenities = List<SWBAmenityModel>()

    //General conditions
    var generalCondition: SWBGeneralCondition? {
        get {
            return SWBGeneralCondition(rawValue: self.condition!)
        }set(newValue) {
            self.condition = newValue?.rawValue
        }
    }
    dynamic var condition: String? = "good"

    //Orientation
    //true garden orientation is being hidden on _garden
    var gardenOrientation: SWBOrientationProtocol? {
        get {
            return SWBOrientationModel(_orientation:self.gardenLocation)
        }set (newValue) {
            self.gardenLocation = newValue?.orientation?.rawValue
        }
    }

    //true garden orientation is being hidden on _terrace
    var terraceOrientation: SWBOrientationProtocol? {
        get {
            return SWBOrientationModel(_orientation:self.terraceLocation)
        }set (newValue) {
            self.terraceLocation = newValue?.orientation?.rawValue
        }
    }

    override static func ignoredProperties() -> [String] {
        return ["rooms", "plans", "generalCondition", "gardenOrientation", "terraceOrientation"]
    }

    func addOrRemoveAmenity(amenity: SWBAmenity) {
        let filteredAmenities = self.amenities.filter({$0.amenity == amenity})
        let amenityExists = filteredAmenities.count > 0
        try! realm?.write({
            if amenityExists {
                self.realm!.delete(filteredAmenities)
            } else {
                self.amenities.append(SWBAmenityModel(value: ["_amenity": amenity.rawValue]))
            }
        })
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension SWBPropertyRoomClass:SWBJSONMapper {
    func initWithJSON(json: JSON) {
        self.id = self.property?.id ?? NSUUID().UUIDString.lowercaseString

        let amenities = json["amenities"].array ?? []
        for amenity in amenities {
            self.amenities.append(SWBAmenityModel(value:["property":self, "_amenity":amenity.stringValue, "id": self.id]))
        }
        let structure: JSON = json["structure"]

        self.floors = structure["floors"].int ?? 0
        self.condition = json["general_condition"].string ?? "good"

        let orientations: JSON = json["orientation"]

        //Get garden orientation on set nil
        let gardenOrientation = SWBOrientation(rawValue: orientations["garden"].stringValue)
        self.gardenLocation = (gardenOrientation == nil) ? nil : gardenOrientation?.rawValue

        //Get terrace orientation on set nil
        let terraceOrientation = SWBOrientation(rawValue: orientations["terrace"].stringValue)
        self.terraceLocation = (terraceOrientation == nil) ? nil : terraceOrientation?.rawValue

        let roomsJson = structure["rooms"].dictionaryValue
        for (key, roomJson) in roomsJson {
            let room = SWBRoomClass(value:["id":key])
            room.initWithJSON(roomJson)
            self.rooms.append(room)
        }

    }
}
