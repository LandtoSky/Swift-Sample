//
//  CRMContact.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum CRMContactType: String {
    case Lead = "lead"
    case Vendor = "vendor"
}

class CRMContact: Object {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var first_name: String?
    dynamic var last_name: String?
    dynamic var phone: String?
    dynamic var is_whatsapp_user: Bool = false
    dynamic var email: String?
    private dynamic var created_at: String?
    private dynamic var updated_at: String?
    dynamic var note: String?
    dynamic var address: CRMContactAddress?
    dynamic var photo: CRMContactPhoto?
    dynamic var is_archived: Bool = false
    private dynamic var type: String? = "lead"
    /// Only available when the contact is a lead
    dynamic var preferences: CRMContactPreferences?

    var contactType: CRMContactType? {
        get {
            return CRMContactType(rawValue: self.type ?? "")
        } set(newValue) {
            self.type = newValue?.rawValue
        }
    }

    var abbreviation: String {
        /**
         Get the first letters from the full name.
         Examples:
         1) Harry Potter = HP
         2) Voldemort = V
         3) One Two Four = OT
        */
        let letters: [String] = self.fullName.componentsSeparatedByString(" ").filter({$0 != ""}).map({String($0.characters.first!) ?? ""})
        return (letters.prefix(2).joinWithSeparator("") ?? "").uppercaseString
    }

    var fullName: String {
        let name: [String] = [self.first_name ?? "", self.last_name ?? ""]
        return name.joinWithSeparator(" ")
    }

    var createdAt: NSDate? {
        get {
            return Formatter.jsonDateTimeFormatter.dateFromString(self.created_at ?? "")
        } set (newValue) {
            self.created_at = Formatter.jsonDateTimeFormatter.stringFromDate(newValue!)
        }
    }
    var updatedAt: NSDate? {
        get {
            return Formatter.jsonDateTimeFormatter.dateFromString(self.updated_at ?? "")
        } set (newValue) {
            self.updated_at = Formatter.jsonDateTimeFormatter.stringFromDate(newValue!)
        }
    }
    func toJSON() -> [String: AnyObject] {
        return [
            "id": self.id,
            "first_name": self.first_name ?? "",
            "last_name": self.last_name ?? "",
            "phone": self.phone ?? "",
            "is_whatsapp_user": self.is_whatsapp_user,
            "email": self.email ?? "",
            "note": self.note ?? ""
        ]
    }
    override static func ignoredProperties() -> [String] {
        return ["createdAt", "updatedAt", "image"]
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension CRMContact: SWBJSONMapper {
    func initWithJSON(json: JSON) {
        self.id = json["id"].stringValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].string
        self.phone = json["phone"].stringValue
        self.note = json["note"].stringValue
        self.email = json["email"].stringValue
        self.is_whatsapp_user = json["is_whatsapp_user"].boolValue
        self.is_archived = json["is_archived"].boolValue
        self.type = json["type"].string ?? "lead"

        let address = CRMContactAddress(value: ["contact": self])
        address.initWithJSON(json["address"])
        self.address = address

        let photo = CRMContactPhoto(value: ["contact": self])
        photo.initWithJSON(json["photo"])
        self.photo = photo

        if self.contactType == .Lead {
            let preferences = CRMContactPreferences(value: ["contact": self])
            preferences.initWithJSON(json["preferences"])
            self.preferences = preferences
        }
    }
}
