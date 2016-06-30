//
//  SWBDescriptionService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/10/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

struct SWBDescriptionParameter {
    var id: String
    var title: String
    var desc: String
}

protocol SWBDescriptionServiceProtocol: SWBService {
    func updateDescriptionAndtitle(property: SWBDescriptionParameter)
}

class SWBDescriptionService: NSObject, SWBDescriptionServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()
    func getUpdateDescriptionAndtitleOperations (property: SWBDescriptionParameter) -> [NSOperation] {

        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateDescriptionOP = SWBRoutes.updateDescription(property)
        let updateProperty = NSBlockOperation {

            NSLog("updateDescriptionAndtitle: started")
            let realm = try! Realm()

            let properties = realm.objects(SWBPropertyModel).filter("id == %@", property.id)
            realm.beginWrite()
            properties.setValue(property.title, forKey: "title")
            properties.setValue(property.desc, forKey: "desc")
            properties.setValue(NSDate(), forKey: "updated_at")
            try! realm.commitWrite()
            NSLog("updateDescriptionAndtitle: finished")
        }

        updateDescriptionOP.addDependency(accessTokenOp)
        updateDescriptionOP.addDependency(updateProperty)
        return [updateDescriptionOP, updateProperty, accessTokenOp]
    }
    func updateDescriptionAndtitle(property: SWBDescriptionParameter) {
        self.queue.addOperations(self.getUpdateDescriptionAndtitleOperations(property), waitUntilFinished: false)
    }
}
