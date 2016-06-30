//
//  SWBRoutes+Description.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/10/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire

extension SWBRoutes {

    class func updateDescription(property: SWBDescriptionParameter, completionHandler: Response<AnyObject, NSError> -> Void = {_ in}) -> NSOperation {
        return NSBlockOperation {
            NSLog("updateDescription server: started")

            //create the parameters
            let parameters = [
                [
                    "op":"add",
                    "path":"/description",
                    "value":[
                        "title":property.title,
                        "description":property.desc
                    ]
                ]
            ]

            self.updatePropertyRequest(property.id, parameters: parameters, completionHandler: completionHandler)

            NSLog("updateDescriptionAndtitle server: finished")
        }
    }
}
