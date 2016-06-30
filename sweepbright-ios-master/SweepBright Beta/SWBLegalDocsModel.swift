//
//  SWBLegalDocsModel.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

protocol SWBLegalDocs: SWBJSONMapper, SWBRealmRequired {
    var notes: String {get set}
    var purchasedYear: Int {get set}
    var property: SWBPropertyModel? {get}
    var startDate: NSDate? {get set}
    var endDate: NSDate? {get set}
    var epcValue: Int? {get set}
    var epcCategory: String? {get set}
}

extension SWBLegalDocs {
    func toJSON() -> [String : AnyObject] {
        return ["notes": self.notes, "purchased_year": self.purchasedYear, "epc_value": self.epcValue ?? 0, "epc_category": self.epcCategory ?? ""]
    }
}

class SWBLegalDocsModel: Object, SWBLegalDocs {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var notes: String = ""
    dynamic var purchasedYear: Int = 2016
    dynamic var property: SWBPropertyModel?
    dynamic var startDate: NSDate?
    dynamic var endDate: NSDate?
    var epcValue: Int? {
        get {
            return self.epc_value.value
        } set (newValue) {
            self.epc_value.value = newValue
        }
    }
    let epc_value = RealmOptional<Int>()
    dynamic var epcCategory: String?

    func initWithJSON(json: JSON) {
        self.id = self.property?.id ?? self.id
        let energyJson = json["energy"]
        self.notes = energyJson["notes"].stringValue
        self.epcValue = energyJson["epc_value"].intValue
        self.epcCategory = energyJson["epc_category"].stringValue

        self.purchasedYear = energyJson["purchased_year"].intValue

        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"

        let tenantJson = json["tenant_contract"]
        self.startDate = formatter.dateFromString(tenantJson["start_date"].stringValue)
        self.endDate = formatter.dateFromString(tenantJson["end_date"].stringValue)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
