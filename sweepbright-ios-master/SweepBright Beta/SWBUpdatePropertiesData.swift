//
//  SWBUpdatePropertiesData.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class SWBAddOrUpdateProperty: NSOperation {
    var json: JSON!
    let realm: Realm!

    init(json: JSON, realm: Realm? = nil) {
        self.json = json
        self.realm = (realm == nil) ? try! Realm(): realm
    }

    override func main() {

        //Populating property with a json
        let property = SWBPropertyModel()
        property.initWithJSON(json)

        try! realm.write {
            //Add or update a property
            realm.add(property, update: true)
        }
    }
}

class SWBUpdatePropertiesData: NSOperation {
    var json: SWBPropertiesJSONWrapper!
    var archivedItens: [String]!
    var realm: Realm!

    init(json: SWBPropertiesJSONWrapper) {
        self.json = json
        self.archivedItens = []
    }
    func processJSON(jsonObj: JSON?) {

        //offline scenario
        guard let jsonObj = jsonObj else {
            NSLog("There is no json to update the properties")
            return
        }

        //Loop on the json
        for (_, json) in jsonObj["data"] {

            let archived = json["is_archived"].boolValue
            if archived {
                archivedItens.append(json["id"].stringValue)
            } else {
                //Populating property with a json
                let property = SWBPropertyModel()
                property.initWithJSON(json)

                //Add or update a property
                realm.add(property, update: true)
            }
        }
    }

    func removeArchiveds() {
        //Delete archiveds
        realm.delete(realm.objects(SWBPropertyModel).filter("id IN %@", archivedItens))
        self.archivedItens = []
    }

    override func main() {
        self.realm = try! Realm()
        NSLog("SWBUpdatePropertiesData: started")
        //start transaction
        realm.beginWrite()

        self.processJSON(self.json.json)
        self.processJSON(self.json.projectsJSON)

        self.removeArchiveds()

        //Commit the transaction
        //PS: This will update the UI
        try! realm.commitWrite()

        NSLog("SWBUpdatePropertiesData: finished")
    }
}
