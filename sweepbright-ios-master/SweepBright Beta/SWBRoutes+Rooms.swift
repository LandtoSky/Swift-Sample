//
//  SWBRoutes+Rooms.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/17/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire

extension SWBRoutes {

    class func getUpdateOrientationOperation(propertyId: String, orientationType: SWBOrientationType, orientation: SWBOrientation, wrapperJson: SWBWrapperJSON? = nil) -> NSOperation {

        return NSBlockOperation {
            NSLog("getUpdateOrientationOperation:started")
            let parameters = [
                [
                    "op":"add",
                    "path":"/orientation/\(orientationType.rawValue)",
                    "value":orientation.rawValue
                ]
            ]

            //update the orientation
            self.updatePropertyRequest(propertyId, parameters: parameters, wrapperJson: wrapperJson, completionHandler: {
                _ in
            })

            NSLog("getUpdateOrientationOperation:finished")
        }
    }

    class func updateRoomsOfaProperty(propertyId: String, wrapper: SWBRoomWrapper) -> NSOperation {
        return NSBlockOperation {
            NSLog("updateRoomsOfaProperty: started")

            self.updatePropertyRequest(propertyId, parameters: wrapper.parameters, completionHandler: {
                _ in

            })
            NSLog("updateRoomsOfaProperty: finished")
        }
    }
}
