//
//  CRMContactPreferences.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CRMLocationPreference: Object, SWBJSONMapper {
    dynamic var id: String = NSUUID().UUIDString
    dynamic var name: String = ""
    let contacts = LinkingObjects(fromType: CRMContactPreferences.self, property: "locations")
    override class func primaryKey() -> String? { return "id" }

    func initWithJSON(json: JSON) {
        self.id = json["id"].string ?? self.id
        self.name = json["name"].stringValue
    }
}

class CRMContactPreferences: Object {
    dynamic var id: String = NSUUID().UUIDString
    dynamic var contact: CRMContact?
    let min_rooms = RealmOptional<Int>()
    let max_price = RealmOptional<Float>()
    dynamic var is_investor: Bool = false
    dynamic var negotiation: String?
    let locations = List<CRMLocationPreference>()

    override class func primaryKey() -> String? { return "id" }
}

extension CRMContactPreferences: SWBJSONMapper {
    func initWithJSON(json: JSON) {
        self.id = self.contact?.id ?? self.id
        self.min_rooms.value = json["min_rooms"].int
        self.max_price.value = json["max_price"].float
        self.is_investor = json["is_investor"].boolValue
        self.negotiation = json["negotiation"].string
    }
}
