//
//  SWBRoutes.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class SWBWrapperJSON: NSObject {
    var json: JSON?
}

typealias CompletionBlock = () -> ()

class SWBRoutes {
    internal static let authQueue = NSOperationQueue()

    internal static let SWBSERVERURL: String = "https://api.sweepbright.mwlhq.com"
    internal static let SWBCLIENTSECRET: String = "zEt4XipZenULVm0J"
    internal static let SWBCLIENTID: String = "HZKSMllrs6LInlOE"
    static var globalResponseHandler: (Response<AnyObject, NSError> -> Void)?

    class internal func getRegisterToken() -> NSOperation {
        if let _ = SWBKeychain.get(.RegisterToken) {
            return NSBlockOperation { }
        } else {
            return SWBAuthService().getRegisterToken()
        }
    }

    class internal func getAccessToken() -> NSOperation {
        let authService = SWBAuthService()
        if authService.tokenIsValid() {
            return NSBlockOperation { }
        } else {
            return authService.refreshAccessToken()
        }
    }

    class func setValueForPropertyRaw(propertyId: String, op: String = "add", path: String, value: AnyObject, completionHandler: (Response<AnyObject, NSError> -> Void)?) -> NSOperation {
        return NSBlockOperation {
            NSLog("setValueForPropertyRaw: started")
            let parameters = [
                [
                    "op":op,
                    "path":"\(path)",
                    "value":value
                ]
            ]

            updatePropertyRequest(propertyId, parameters: parameters, completionHandler: {
                response in
                completionHandler?(response)
            })

            NSLog("setValueForPropertyRaw: finished")
        }
    }
    class func setValueForProperty(propertyId: String, path: String, key: String, value: AnyObject, completionHandler: Response<AnyObject, NSError> -> Void) -> NSOperation {
        return NSBlockOperation {
            let path = path.stringByReplacingOccurrencesOfString("/", withString: "")
            NSLog("setValueForProperty:\(key): started")
            let parameters = [
                [
                    "op":"add",
                    "path":"/\(path)/\(key)",
                    "value":value
                ]
            ]

            updatePropertyRequest(propertyId, parameters: parameters, completionHandler: {
                response in
                completionHandler(response)
                globalResponseHandler?(response)
            })

            NSLog("setValueForProperty:\(key): finished")
        }
    }

    internal class func updatePropertyRequest(propertyId: String, parameters: AnyObject?, wrapperJson: SWBWrapperJSON? = nil, completionHandler: Response<AnyObject, NSError> -> Void) {

        //Populate the header
        let headers = [
            "Content-Type": "application/json-patch+json",
            "Authorization": "Bearer \(SWBKeychain.get(.AccessToken) ?? "")"
        ]

        let realm = try! Realm()
        let property = realm.objectForPrimaryKey(SWBPropertyModel.self, key: propertyId)
        let isProject = property?.project != nil

        //send the request
        SWBSynchronousRequestFactory.sharedInstance.safeSynchronousRequest(.PATCH, url: "\(self.SWBSERVERURL)/\(isProject ? "projects" : "properties" )/\(propertyId)", parameters: parameters, headers:headers, completionHandler: {
            response in
            if response.response?.statusCode <= 299 {

                if let value = response.result.value {
                    let json = JSON(value)
                    wrapperJson?.json = json

                    //Update the property after the request
                    SWBAddOrUpdateProperty(json: json["data"]).start()
                }

            } else {
                debugPrint("Status Code: \(response.response?.statusCode)")
                debugPrint(response)
            }
            completionHandler(response)
        })
    }
//
//    class func refreshToken() {
//
//        let refreshTokenBlock = self.authRefreshToken()
//
//        //Add operations to the queue
//        self.authQueue.addOperations([refreshTokenBlock], waitUntilFinished: false)
//    }

}
