//
//  SWBVisit.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

protocol SWBVisit: SWBJSONMapper, SWBRealmRequired {
    var id: String {get set}
    var currentlyVacant: Bool {get set}
    var details: String {get set}
    var keyInPossesion: Bool {get set}
    var property: SWBPropertyModel? {get set}
    var alarmCode: String {get set}
    var alarmOnProperty: Bool {get set}
}

//Access
class Access: Object, SWBVisit {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var currentlyVacant = false
    dynamic var details = ""
    dynamic var keyInPossesion = false
    dynamic var alarmCode: String = ""
    dynamic var alarmOnProperty = false
    dynamic var property: SWBPropertyModel?

    override static func primaryKey() -> String? {
        return "id"
    }
}

//MARK: JSON Mapper
extension Access {
    func initWithJSON(json: JSON) {
        self.id = self.property?.id ?? NSUUID().UUIDString.lowercaseString
        self.currentlyVacant = json["occupancy", "vacant"].boolValue
        self.details = json["occupancy", "contact_details"].stringValue

        self.keyInPossesion = json["accessibility", "key_available"].boolValue
        self.alarmOnProperty = json["accessibility", "alarm"].boolValue
        self.alarmCode = json["accessibility", "alarm_code"].stringValue
    }
}
