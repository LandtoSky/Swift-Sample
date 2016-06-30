//
//  SWBAccessService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

protocol SWBAccessServiceProtocol: SWBService {
    func syncAccess(access: Access, completionBlock: (()->())?)
}
extension SWBAccessServiceProtocol {
    func syncAccess(access: Access) {
        self.syncAccess(access, completionBlock: nil)
    }
}

class SWBAccessService: SWBAccessServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()
    func syncAccess(access: Access, completionBlock: (()->())? = nil) {
        //Preventing realm thread exception
        let access = Access(value: access)
        let propertyID = access.id
        let propertyType = access.property?.type

        let occupancyParameters  = [
            "vacant" : access.currentlyVacant,
            "contact_details" : access.details
        ]

        //land properties only has the key_available parameter
        let accessParameters = propertyType == .Land
            ? [ "key_available" : access.keyInPossesion]
            : [ "key_available" : access.keyInPossesion,
                "alarm": access.alarmOnProperty,
                "alarm_code": access.alarmCode
        ]

        //sync occupancy informations
        let value = [
            [
                "op": "add",
                "path": "/occupancy",
                "value" : occupancyParameters
            ],
            [
                "op": "add",
                "path": "/accessibility",
                "value" : accessParameters
            ]
        ]
        self.sendMultipleOperations(toPropertyId: propertyID, value: value, completionBlock: completionBlock)
    }
}
