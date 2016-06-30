//
//  PropertyUnit.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol SWBProjectProtocol {
    var id: String {get set}
    var level: String {get set}
    var price: Float {get set}
    var totalOfRooms: Int {get set}
    var listOfUnits: [SWBProjectProtocol] { get }
}

class SWBProjectModel: Object, SWBProjectProtocol {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var property: SWBPropertyModel?
    var level: String = "BG"
    var price: Float = 0.0
    var totalOfRooms: Int = 1
    var listOfUnits: [SWBProjectProtocol] = []

    override class func primaryKey() -> String {
        return "id"
    }
}
