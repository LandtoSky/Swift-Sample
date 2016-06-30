//
//  SWBRealmRequired.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol SWBRealmRequired {
    var id: String {get set}
    var property: SWBPropertyModel? {get set}
}

extension SWBRealmRequired where Self: Object {
    static func primaryKey() -> String? {
        return "id"
    }
}
