//
//  SWBPropertySettings.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum SWBPropertyStatusSettings: String {
    case Available = "available"
    case Option = "option"
    case Bid = "bid"
    case Rented = "rented"
    case Sold = "sold"
    case Closed = "closed"

    func getLetStatus() -> [SWBPropertyStatusSettings] {
        return [.Available, .Option, .Bid, .Rented]
    }

    func getSaleStatus() -> [SWBPropertyStatusSettings] {
        return [.Available, .Option, .Bid, .Sold, .Closed]
    }

}

protocol SWBPropertySettings: SWBRealmRequired, SWBJSONMapper {
    var notes: String? {get set}

    //Advertisement
    var from: NSDate? {get set}
    var allowed: Bool {get set}

    //Mandate
    var startDate: NSDate? {get set}
    var endDate: NSDate? {get set}

    //office
    var negotiator: String? {get set}
    var reference: String? {get set}

    //Status
    var statusProperty: SWBPropertyStatusSettings {get set}
}

class SWBPropertySettingsModel: Object, SWBPropertySettings {
    dynamic var id: String = NSUUID().UUIDString
    dynamic var property: SWBPropertyModel?
    dynamic var notes: String?
    dynamic var from: NSDate?
    dynamic var allowed: Bool = false
    dynamic var startDate: NSDate?
    dynamic var endDate: NSDate?
    dynamic var negotiator: String?
    dynamic var reference: String?
    var statusProperty: SWBPropertyStatusSettings {
        get {
            return SWBPropertyStatusSettings(rawValue: self.status) ?? .Available
        }
        set (newValue) {
            self.status = newValue.rawValue
        }
    }
    private dynamic var status: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    func initWithJSON(json: JSON) {
        self.id = self.property?.id ?? NSUUID().UUIDString
        let settingsJson = json["settings"]
        self.notes = settingsJson["internal_note"].string
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"

        //Advertisement
        let advertisement = settingsJson["advertisement"]
        self.allowed = advertisement["allowed"].boolValue
        self.from = formatter.dateFromString(advertisement["from"].stringValue)

        //Mandate
        let mandate = settingsJson["mandate"]
        self.startDate = formatter.dateFromString(mandate["start_date"].stringValue)
        self.endDate = formatter.dateFromString(mandate["end_date"].stringValue)

        //Office
        let office = settingsJson["office"]
        self.negotiator = office["negotiator"].stringValue
        self.reference = office["reference"].stringValue

        //Status
        self.status = json["status"].stringValue
    }
}
