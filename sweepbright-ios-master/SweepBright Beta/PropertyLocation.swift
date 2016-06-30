//
//  PropertyLocation.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import SwiftyJSON

protocol SWBPropertyLocation: NSObjectProtocol, SWBJSONMapper {
    var id: String { get set }
    var street: String? { get set }
    var street2: String? {get set}
    var nr: String? { get set }
    var add: String? { get set }
    var box: String? { get set }
    var floor: String? { get set }
    var postcode: String? { get set }
    var city: String? { get set }
    var province: String? { get set }
    var country: String? { get set }
    var isPublic: Bool {get set}
    var coordinate: CLLocationCoordinate2D { get set }
}

extension SWBPropertyLocation {

    func toJSON() -> Dictionary<String, AnyObject> {
        var json: Dictionary<String, AnyObject> = [:]
        json["street"] = self.street
        json["street_2"] = self.street2
        json["number"] = self.nr
        json["addition"] = self.add
        json["box"] = self.box
        json["floor"] = self.floor
        json["postal_code"] = self.postcode
        json["city"] = self.city
        json["province_or_county"] = self.province
        json["country"] = self.country?.uppercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        json["public"] = self.isPublic
        json["geo"] = [
            "latitude":Double(self.coordinate.latitude ?? 0),
            "longitude":Double(self.coordinate.longitude ?? 0)
        ]

        //clean empty values
        for key in json.keys {
            let value = json[key]
            if value == nil {
                json.removeValueForKey(key)
            } else if let valueString: String = value as? String {
                if valueString.isEmpty {
                 json.removeValueForKey(key)
                }
            }
        }
        debugPrint(JSON(json))
        return json
    }
}

class SWBPropertyLocationModel: Object, SWBPropertyLocation {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var street: String? = ""
    dynamic var street2: String? = ""
    dynamic var nr: String? = ""
    dynamic var add: String? = ""
    dynamic var box: String? = ""
    dynamic var floor: String? = ""
    dynamic var postcode: String? = ""
    dynamic var city: String? = ""
    dynamic var province: String? = ""
    dynamic var country: String? = ""
    dynamic var isPublic: Bool = false
    dynamic var longitude: Double = 0.0
    dynamic var latitude: Double = 0.0

    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
        set(newValue) {
            self.latitude = newValue.latitude ?? 0.0
            self.longitude = newValue.longitude ?? 0.0
        }
    }

    func initWithJSON(json: JSON) {

        self.street = json["street"].string
        self.street2 = json["street_2"].string
        self.nr = json["number"].string
        self.add = json["addition"].string
        self.box = json["box"].string
        self.floor = json["floor"].string
        self.postcode = json["postal_code"].string
        self.city = json["city"].string
        self.province = json["province_or_county"].string
        self.country = json["country"].string
        self.isPublic = json["public"].bool ?? false

        self.latitude = json["geo", "latitude"].doubleValue
        self.longitude = json["geo", "longitude"].doubleValue
    }

    override static func ignoredProperties() -> [String] {
        return ["coordinate"]
    }
}

//Realm
extension SWBPropertyLocationModel {

    override class func primaryKey() -> String {
        return "id"
    }
}
