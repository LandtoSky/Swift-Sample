//
//  SWBPropertyService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import JDStatusBarNotification

typealias PropertyID = String
protocol SWBPropertyServiceProtocol {
    func createNewProperty(property: SWBPropertyModel, completionBlock: CompletionBlock?) -> PropertyID
    func createNewProperty(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock?) -> PropertyID
    func createProject(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock?) -> PropertyID
    func updateListOfProperties(completionBlock: CompletionBlock?)
}

class SWBPropertyService: SWBPropertyServiceProtocol {
    let queue = NSOperationQueue()

    func createProject(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock?) -> PropertyID {

        let property = SWBPropertyModel(value: ["propertyType": type.rawValue, "negotiation": negotiation.rawValue])
        let realm = try! Realm()
        realm.add(project: property)

        //server token for sync
        let syncToken = SWBRoutes.getAccessToken()

        let newProjectOp = SWBRoutes.createNewProject(type, negotiation: negotiation)
        newProjectOp.addDependency(syncToken)
        newProjectOp.completionBlock = completionBlock

        self.queue.addOperations([newProjectOp, syncToken], waitUntilFinished: false)
        return property.id
    }

    func createNewProperty(property: SWBPropertyModel, completionBlock: CompletionBlock? = nil) -> PropertyID {
        //Insert property on database
        let realm = try! Realm()
        realm.add(property: property)

        //server token for sync
        let syncToken = SWBRoutes.getAccessToken()

        //server sync
        let syncOp = SWBRoutes.createNewProperty(property)
        syncOp.addDependency(syncToken)
        syncOp.completionBlock = completionBlock

        self.queue.addOperations([syncToken, syncOp], waitUntilFinished: false)
        return property.id
    }

    func createNewProperty(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock? = nil) -> PropertyID {
        let property = SWBPropertyModel(value: ["propertyType": type.rawValue, "negotiation":negotiation.rawValue])
        return self.createNewProperty(property, completionBlock: completionBlock)
    }

    func updateListOfProperties(completionBlock: CompletionBlock?=nil) {
        JDStatusBarNotification.showWithStatus("Updating list of properties")

        // This is how the threads are working:
        //          Access token
        //          /           \
        //  Projects             Properties
        //          \           /
        //           Update list

        let json = SWBPropertiesJSONWrapper()
        let accessToken = SWBRoutes.getAccessToken()
        let getPropOp = SWBRoutes.getProperties(json)
        let getProjOp = SWBRoutes.getProjects(json)
        let updateData = SWBUpdatePropertiesData(json: json)

        getPropOp.addDependency(accessToken)
        getProjOp.addDependency(accessToken)

        updateData.addDependency(getPropOp)
        updateData.addDependency(getProjOp)
        updateData.completionBlock = {
            debugPrint("Total of properties: \(try! Realm().objects(SWBPropertyModel).count)")
            debugPrint("Total of projects: \(try! Realm().objects(SWBProjectModel).count)")
            dispatch_async(dispatch_get_main_queue(), {
                completionBlock?()
                JDStatusBarNotification.dismissAnimated(true)
            })
        }

        self.queue.addOperations([getPropOp, getProjOp, accessToken, updateData], waitUntilFinished: false)
    }
}
