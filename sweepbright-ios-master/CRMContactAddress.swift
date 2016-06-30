//
//  CRMContactAddress.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
import SwiftyJSON

class CRMContactAddress: Object, SWBPropertyLocation {
    dynamic var contact: CRMContact?
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

    //Unused for contact yet
    internal var isPublic: Bool = false
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    internal var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()

    //MARK: Realm
    override static func ignoredProperties() -> [String] {
        return ["coordinate"]
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    //MARK: JSONWrapper
    func initWithJSON(json: JSON) {
        self.id = self.contact?.id ?? self.id
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
    }

    func toJSON() -> Dictionary<String, AnyObject> {
        var json: Dictionary<String, AnyObject> = [:]
        json["street"] = self.street
        json["number"] = self.nr
        json["addition"] = self.add
        json["box"] = self.box
        json["floor"] = self.floor
        json["postal_code"] = self.postcode
        json["city"] = self.city
        json["province_or_county"] = self.province
        json["country"] = self.country?.uppercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        return json
    }
}
