//
//  SWBNewPropertyAddedNotification.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/16/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation


class SWBNewPropertyAddedNotification {
    static let newPropertyNotificationName = "newPropertyNotificationName"
    class func dispatchNewPropertyHasBeenAdded(propertyWithId property: PropertyID) {
        NSNotificationCenter.defaultCenter().postNotificationName(newPropertyNotificationName, object: property)
    }
}
