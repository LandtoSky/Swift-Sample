//
//  SWBLocationService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/11/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import JDStatusBarNotification

protocol SWBLocationServiceProtocol {
    func updateLocation(propertyId: String, location: SWBPropertyLocationModel, completionBlock: (() -> ())?)
}

class SWBLocationService: SWBLocationServiceProtocol {
    func saveNewLocation(location: SWBPropertyLocationModel) -> NSOperation {
        return NSBlockOperation {
            NSLog("Updating location: Started")
            let realm = try! Realm()
            let newLocation = SWBPropertyLocationModel(value:location)
            try! realm.write({
                realm.add(newLocation, update: true)
            })
            NSLog("Updating location: finished")
        }
    }
    func updateLocation(propertyId: String, location: SWBPropertyLocationModel, completionBlock: (() -> ())?) {
        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateLocationOp = SWBRoutes.updateLocation(propertyId, location: location, completionHandler: {
            response in
        })
        let saveNewLocation = self.saveNewLocation(location)

        updateLocationOp.addDependency(saveNewLocation)
        updateLocationOp.addDependency(accessTokenOp)
        updateLocationOp.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                JDStatusBarNotification.dismissAnimated(true)
                completionBlock?()
            })
        }

        NSOperationQueue().addOperations([saveNewLocation, accessTokenOp, updateLocationOp], waitUntilFinished: false)
    }
}
