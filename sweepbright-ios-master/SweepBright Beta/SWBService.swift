//
//  SWBService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/23/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire

protocol SWBService {
    var queue: NSOperationQueue! {get set}
    func setValueForProperty(propertyId: String, op: String, path: String, value: AnyObject, completionHandler: (Response<AnyObject, NSError> -> Void)?)
}

extension SWBService {
    internal func sendMultipleOperations(toPropertyId propertyId: String, value: AnyObject, completionBlock: (()->())? = nil) {
        let accessTokenOperation = SWBRoutes.getAccessToken()
        let multiplePatches = NSBlockOperation {
            SWBRoutes.updatePropertyRequest(propertyId, parameters: value, completionHandler: {
                _ in
            })
        }

        multiplePatches.addDependency(accessTokenOperation)
        multiplePatches.completionBlock = completionBlock
        self.queue.addOperations([accessTokenOperation, multiplePatches], waitUntilFinished: false)
    }

    internal func setValueForProperty(propertyId: String, op: String, path: String, value: AnyObject, completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) {

        let accessTokenOperation = SWBRoutes.getAccessToken()
        let valuePropertyOperation = SWBRoutes.setValueForPropertyRaw(propertyId, op:op, path: path, value: value, completionHandler: completionHandler)

        valuePropertyOperation.addDependency(accessTokenOperation)

        self.queue.addOperations([accessTokenOperation, valuePropertyOperation], waitUntilFinished: false)
    }
}
