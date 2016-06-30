//
//  SWBRoutes+Location.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/11/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire

extension SWBRoutes {

    class func updateLocation(propertyId: String, location: SWBPropertyLocation, completionHandler: Response<AnyObject, NSError> -> Void) -> NSOperation {
        return NSBlockOperation {
            NSLog("updateLocation server: started")

            //create the parameters
            let parameters = [
                [
                    "op":"add",
                    "path":"/location",
                    "value":location.toJSON()
                ]
            ]

            debugPrint(parameters)

            self.updatePropertyRequest(propertyId, parameters: parameters, completionHandler: {
                response in
                debugPrint(response)

                completionHandler(response)
            })

            NSLog("updateLocation server: finished")
        }
    }
}
