//
//  SWBNewPropertyOperation.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Alamofire

class SWBPropertiesJSONWrapper: SWBWrapperJSON {
    var projectsJSON: JSON?
}

extension SWBRoutes {
    class func createNewProject(type: SWBPropertyType, negotiation: SWBPropertyNegotiation) -> NSOperation {
        return NSBlockOperation {
            let parameters = [
                "id": NSUUID().UUIDString.uppercaseString,
                "type": type.rawValue,
                "negotiation": negotiation.rawValue
            ]

            let header = [
                "Content-Type": "application/json",
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]

            SWBSynchronousRequestFactory.sharedInstance.safeSynchronousRequest(.POST, url: "\(self.SWBSERVERURL)/projects", parameters: parameters, headers: header, completionHandler: {
                response in

                debugPrint(response)
            })
            NSLog("createNewProperty: finished")
        }
    }
    class func createNewProperty(property: SWBProperty) -> NSOperation {
        //Prevent thread issue
        let id = property.id
        let type = property.type.rawValue
        let negotiation = property.status.rawValue

        return NSBlockOperation {
            NSLog("createNewProperty: started")
            //Creating parameters
            let parameters = [
                "id":id,
                "type": type,
                "negotiation":negotiation
            ]

            let header = [
                "Content-Type": "application/json",
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]

            SWBSynchronousRequestFactory.sharedInstance.safeSynchronousRequest(.POST, url: "\(self.SWBSERVERURL)/properties", parameters: parameters, headers: header, completionHandler: {
                response in

                debugPrint(response)
            })
            NSLog("createNewProperty: finished")
        }
    }

    internal class func getProperties(json: SWBPropertiesJSONWrapper) -> NSOperation {
        let getPropertiesOp = NSBlockOperation {
            NSLog("getProperties: started")
            let limit = 500
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.GET, url: "\(self.SWBSERVERURL)/properties?limit=\(limit)", parameters: nil, headers: header, completionHandler: {
                response in
                if let jsonValue = response.result.value {
                    json.json = JSON(jsonValue)
                    NSLog("getProperties: status code \(response.response?.statusCode)")
                } else {
                    NSLog("getProperties: no connection")
                }
            })
            NSLog("getProperties: finished")
        }

        return getPropertiesOp
    }

    internal class func getProjects(json: SWBPropertiesJSONWrapper) -> NSOperation {
        let getPropertiesOp = NSBlockOperation {
            NSLog("getProjects: started")
            let limit = 500
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.GET, url: "\(self.SWBSERVERURL)/projects?limit=\(limit)", parameters: nil, headers: header, completionHandler: {
                response in
                if let jsonValue = response.result.value {
                    json.projectsJSON = JSON(jsonValue)
                    NSLog("getProjects: status code \(response.response?.statusCode)")
                } else {
                    NSLog("getProjects: no connection")
                }
            })
            NSLog("getProjects: finished")
        }

        return getPropertiesOp
    }

    class func getProperty(withId propertyId: String, completionHandler: Response<AnyObject, NSError> -> Void) {
        let header = [
            "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]
        SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.GET, url: "\(self.SWBSERVERURL)/properties/\(propertyId)", parameters: nil, headers: header, completionHandler: completionHandler)
    }
}
