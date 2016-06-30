//
//  CRMContactPhoto.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CRMContactPhoto: Object {
    dynamic var id: String = NSUUID().UUIDString
    var contact: CRMContact?
    ///44x44
    dynamic var small_url: String?
    ///80x80
    dynamic var medium_url: String?
    dynamic var orignal_url: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension CRMContactPhoto: SWBJSONMapper {
    func initWithJSON(json: JSON) {
        self.id = self.contact?.id ?? self.id
        self.small_url = json["data", "44x44"].string
        self.medium_url = json["data", "80x80"].string
        self.orignal_url = json["data", "original"].string
    }
    func toJSON() -> [String : AnyObject] {
        return [:]
    }
}
